#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# checkservices.sh
# Simple helper to check a set of user services and relevant environment variables.
# Prints timestamped lines in the format you showed and then runs the checks.

DEFAULT_SERVICES=(
	waybar.service
	swww-daemon.service
	swww.service
	polkit-kde-agent.service
)

print_usage() {
	cat <<EOF
Usage: $0 [options]

Options:
	-n, --noop            Print the timestamped commands only (dry-run), don't execute
	-s, --services LIST   Comma-separated list of services to check (overrides discovery)
	-d, --dir DIR         Directory to discover .service files (default: ~/.config/systemd/user or XDG alternative)
	-v, --verbose         Print full `systemctl --user status` output (default: summary-only)
	-h, --help            Show this help

Examples:
	$0 --noop
	$0 --services "waybar.service,swww.service"
	$0 --dir /home/matt/dotfiles/systemd/.config/systemd/user
EOF
}

NOOP=0
CUSTOM_SERVICES=""
SERVICE_DIR=""
VERBOSE=0

while [[ ${#@} -gt 0 ]]; do
	case "$1" in
		-n|--noop) NOOP=1; shift ;;
		-s|--services) CUSTOM_SERVICES="$2"; shift 2 ;;
		-d|--dir) SERVICE_DIR="$2"; shift 2 ;;
			-v|--verbose) VERBOSE=1; shift ;;
		-h|--help) print_usage; exit 0 ;;
		--) shift; break ;;
		-*) echo "Unknown option: $1" >&2; print_usage; exit 2 ;;
		*) break ;;
	esac
done

# Find a directory with user service units
discover_service_dir() {
	if [[ -n "$SERVICE_DIR" ]]; then
		echo "$SERVICE_DIR"
		return
	fi
	# prefer XDG if set
	if [[ -n "${XDG_CONFIG_HOME-}" ]] && [[ -d "$XDG_CONFIG_HOME/systemd/user" ]]; then
		echo "$XDG_CONFIG_HOME/systemd/user"
		return
	fi
	if [[ -d "$HOME/.config/systemd/user" ]]; then
		echo "$HOME/.config/systemd/user"
		return
	fi
	# common dotfiles fallback (helpful when using a dotfiles repo layout)
	if [[ -d "$HOME/dotfiles/systemd/.config/systemd/user" ]]; then
		echo "$HOME/dotfiles/systemd/.config/systemd/user"
		return
	fi
	# last-resort: return empty
	echo ""
}

svc_dir=$(discover_service_dir)

discover_services() {
	local arr=()
	if [[ -n "$CUSTOM_SERVICES" ]]; then
		IFS=',' read -r -a arr <<< "$CUSTOM_SERVICES"
		printf '%s\n' "${arr[@]}"
		return
	fi
	if [[ -n "$svc_dir" ]]; then
		# use a null-safe loop; if glob doesn't match, the pattern is left untouched so guard it
		shopt -s nullglob 2>/dev/null || true
		for f in "$svc_dir"/*.service; do
			[[ -e "$f" ]] || continue
			arr+=("$(basename "$f")")
		done
	fi
	# ensure defaults are present (but don't duplicate)
	for s in "${DEFAULT_SERVICES[@]}"; do
		local found=0
		for existing in "${arr[@]}"; do
			[[ "$existing" == "$s" ]] && found=1 && break
		done
		[[ $found -eq 0 ]] && arr+=("$s")
	done
	printf '%s\n' "${arr[@]}"
}

timestamp() {
	# prints epoch seconds (matching the format you gave)
	date +%s
}

run_check() {
	local service="$1"
	local ts
	ts=$(timestamp)
	printf ": %s:0;systemctl --user status %s\n" "$ts" "$service"
	if [[ $NOOP -eq 0 ]]; then
		# gather concise status fields
		local active unitfile preset
		active=$(systemctl --user is-active "$service" 2>/dev/null || true)
		# systemctl is-active may print nothing on error; normalize
		[[ -z "$active" ]] && active="unknown"
		unitfile=$(systemctl --user show -p UnitFileState "$service" 2>/dev/null | cut -d= -f2 || true)
		[[ -z "$unitfile" ]] && unitfile="unknown"
		preset=$(systemctl --user show -p Preset "$service" 2>/dev/null | cut -d= -f2 || true)
		[[ -z "$preset" ]] && preset="n/a"

		printf "%-30s Active=%-8s UnitFile=%-8s Preset=%s\n" "$service" "$active" "$unitfile" "$preset"

		# show full status only in verbose mode
		if [[ $VERBOSE -eq 1 ]]; then
			systemctl --user --no-pager status "$service" || true
			echo
		fi
	fi
}

run_env_check() {
	local ts
	ts=$(timestamp)
	printf ": %s:0;env | grep -E 'WAYLAND|XDG|DISPLAY'\n" "$ts"
	if [[ $NOOP -eq 0 ]]; then
		env | grep -E 'WAYLAND|XDG|DISPLAY' || true
		echo
	fi
}

# MAIN
mapfile -t services < <(discover_services)

if [[ ${#services[@]} -eq 0 ]]; then
	echo "No services discovered and no defaults available." >&2
	exit 1
fi

for s in "${services[@]}"; do
	run_check "$s"
done

run_env_check

exit 0
