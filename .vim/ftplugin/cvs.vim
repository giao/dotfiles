normal GoCVS: CVS: old, unused cvs-commit logs:CVS: ----------------------------------------------------------------------
r!find /tmp/ -user `id -u` -maxdepth 1 -name "cvs*" \! -name `basename %` -exec cat {} ";" -exec echo "----------------------------------------------------------------------" ";" | sed 's/^/CVS: /'
normal ggO
