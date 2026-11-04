#!/bin/sh
# Typeset a handbook page with XeLaTeX.
#   render.sh path/to/page.tex [expected pages, default 1]
# Writes page.pdf next to the .tex and prints the class's fit check (room left
# above the footer). Exits 3 when the page overflows onto an extra page.
# Handbook-mode documents get a second pass for the contents and no page limit.
set -u
[ -n "${1:-}" ] || { printf 'usage: render.sh page.tex [pages]\n' >&2; exit 2; }
DIR=$(cd "$(dirname "$1")" && pwd)
NAME=$(basename "$1" .tex)
PAGES=${2:-1}
command -v xelatex >/dev/null || { printf 'xelatex not found: install TeX Live or MacTeX\n' >&2; exit 1; }

cd "$DIR" || exit 1
# max_print_line: TeX wraps log lines at 79 chars, which splits the
# "Output written on NAME.pdf (N pages" line for long page names.
run() {
  max_print_line=10000 xelatex -interaction=nonstopmode -halt-on-error "$NAME.tex" >/dev/null && return
  grep -A6 '^!' "$NAME.log" >&2
  exit 1
}
run
FIT=$(sed -n 's/^NH-FIT: //p' "$NAME.log")
[ "$FIT" = handbook ] && run
rm -f "$NAME.aux" "$NAME.toc" "$NAME.lof" "$NAME.lot"

GOT=$(sed -n 's/^Output written on .* (\([0-9]*\) pages\{0,1\}.*/\1/p' "$NAME.log")
[ -n "$GOT" ] || { printf 'could not read the page count from %s.log\n' "$NAME" >&2; exit 1; }
printf 'pdf: %s\n' "$DIR/$NAME.pdf"
[ "$FIT" = handbook ] && FIT="handbook, $GOT pages"
printf 'fit: %s\n' "$FIT"
grep -E '^(Overfull|LaTeX Warning)' "$NAME.log" | sort | uniq -c | sed 's/^/warn: /'
case $FIT in handbook*) exit 0 ;; esac
if [ "$GOT" -gt "$PAGES" ]; then
  printf 'page overflows: %s pages, expected %s. Cut words or a table row, not type size\n' "$GOT" "$PAGES" >&2
  exit 3
fi
