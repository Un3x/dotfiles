# Sizing captures

Read at step 4 of `gh-image`, and when images already on GitHub are too big.

GitHub draws a markdown image at its natural size, capped at the body width (about 880 px): a phone capture (750 × 1334 at 2x) fills more than a screen and before/after can no longer be compared. Check the dimensions before uploading:

```bash
python3 -c 'import struct,sys; d=open(sys.argv[1],"rb").read(24); print(*struct.unpack(">II", d[16:24]))' a.png
```

- Crop a very tall image (a full-page capture) to the part that matters, about a screen ratio, under a new name, before attaching it.
- After the upload, replace each `![alt](https://github.com/user-attachments/…)` of a portrait capture by `<img src="…" alt="alt" width="240">`, and put the images to compare on the same line, separated by a space, so they render side by side (mockup, before, after).
- Attach with `![alt](/abs/path)` first, since gh does not rewrite an `<img src>` holding a local path; then fetch the saved body, swap in the `<img>` tags and save it with `gh pr edit --body-file` without `--attach`, which would upload the files a second time.

Images already on GitHub that are too big: the same swap on the saved body, no upload.
