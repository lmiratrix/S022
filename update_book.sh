cd book-output
git pull
git rm -rf *
cp -r ../_book/* ./
touch .nojekyll
git add --all *
git add .nojekyll
git commit -m "Update the book"
git push -q origin gh-pages
