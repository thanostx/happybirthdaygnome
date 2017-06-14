#! /bin/bash -e

# make sure all HTML files are valid XML, this will be required by xml2po
# in the second phase...
for HTMLFILE in $(ls ../*.html)
do
    xmllint --noout $HTMLFILE
done

xml2po -e -m xhtml -o gnome-birthday.pot $(ls ../*.html)
for LANG in $(cat LINGUAS)
do
    POFILE=$LANG.po
    for HTMLFILE in $(ls ../*.html)
    do
      echo "Writing $HTMLFILE.$LANG"
      xml2po -p $POFILE -m xhtml -o $HTMLFILE.$LANG $HTMLFILE
      grep -q '<html lang="en"' $HTMLFILE.$LANG && \
        sed -i -e "s/lang=\"en\"/lang=\"$LANG\"/" $HTMLFILE.$LANG
      grep -q '<script src' $HTMLFILE.$LANG && \
        sed -i -e 's/\(<script src.*\)/\1<\/script>/' $HTMLFILE.$LANG
      grep -q '<span' $HTMLFILE.$LANG && \
        sed -i -e 's/\(<span.*\)/\1<\/span>/' $HTMLFILE.$LANG
      grep -q 'index.html\"' $HTMLFILE.$LANG && \
        sed -i -e "s/index.html\"/index.html.$LANG\"/" $HTMLFILE.$LANG
    done
done

for HTMLFILE in ../*.html
do
    cp $HTMLFILE $HTMLFILE.en
done
