#!/bin/bash
# Genera CHANGELOG.md agrupando los commits por tipo

seccion() {
  local prefijo="$1"
  local titulo="$2"
  local commits
  commits=$(git log --no-merges --pretty=tformat:"- %s (%h)" --grep="^$prefijo:" \
            | sed "s/^- $prefijo: /- /")
  if [ -n "$commits" ]; then
    echo "## $titulo"
    echo
    echo "$commits"
    echo
  fi
}

{
  echo "# Changelog"
  echo
  echo "_Generado el $(date +%F)_"
  echo
  seccion "feat" "Nuevas funcionalidades"
  seccion "fix"  "Correcciones"
  seccion "docs" "Documentación"

  otros=$(git log --no-merges --pretty=tformat:"- %s (%h)" \
          --invert-grep --grep="^feat:" --grep="^fix:" --grep="^docs:")
  if [ -n "$otros" ]; then
    echo "## Otros cambios"
    echo
    echo "$otros"
  fi
} > CHANGELOG.md

echo "CHANGELOG.md actualizado"
