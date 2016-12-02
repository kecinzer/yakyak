VERSION=$1

echo "Creating release"

git pull --rebase
git tag "v$VERSION"
git push --tag
github-release release --repo yakyak --user yakyak \
  --name "$VERSION" --tag "v$VERSION" --pre-release

cd dist
for file in $(ls yakyak-*); do
  echo "Uploading $file.."
  github-release upload --repo yakyak --user yakyak --tag "v$VERSION" \
    --file $file --name $file
  echo "  ..uploaded successfully"
done
cd ..

echo "All files uploaded."
