VERSION=$1

set -e

echo "Creating release"

REMOTE_DIR="yakyak/dist"

for item in linux-ia32 linux-x64 win32-ia32 win32-x64 darwin-x64; do
  echo "$item"
  rsync -pavzc --delete dist/$item vblit:~/$REMOTE_DIR/
  ssh vblit "cd $REMOTE_DIR && rm -f yakyak-$item.zip; zip -r -y -X yakyak-$item.zip $item"
done

git pull --rebase
git tag -f "v$VERSION"
git push --tag --force
set +e
github-release release --repo yakyak --user yakyak \
  --name "$VERSION" --tag "v$VERSION" --pre-release
set -e

ssh vblit "
export GITHUB_TOKEN=45ac90ba62a4ffa11b17e29685caa800b68fd005
export GITHUB_USER=davibe
cd $REMOTE_DIR && \
for file in \$(ls |grep zip); do
  echo \$file
  echo \"Uploading \$file..\"
  until [ 1 == 0 ]; do
    \$HOME/go/bin/github-release -v upload --repo yakyak --user yakyak --tag \"v$VERSION\" \
      --file \$file --name \$file && break
    echo 'Trying again..'
  done
  echo \"  ..uploaded successfully\"
done
cd ..
"


echo "All files uploaded."
