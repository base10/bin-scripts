# binscrpt-prompt-001-01-1-to-1

## Meta

Start date: 2026-11-18
Model: Gemma 4 12B IT QAT Optiq
OpendCode session name: ses_binscrpt-prompt-001-01-1-to-1

## Iter. 1

In `/Users/nwalls/code/base10/bin-scripts`, I have a Ruby script, `1to1.rb`. The script builds a 1 to 1 notes file from an ERb template.

Right now, running the script looks like this:

```bash
1to1.rb \
    --date=2026-11-04 \
    --name="Brett Van Dorn" \
    --output-directory=/Users/nwalls/Documents/vitalsource/one-on-one-notes/brett-van-dorn


1to1.rb \
    --date=2026-11-09 \
    --name="Chris Amidon" \
    --output-directory=/Users/nwalls/Documents/vitalsource/one-on-one-notes/chris-amidon

1to1.rb \
    --date=2026-11-12 \
    --name="Sean McKeever" \
    --output-directory=/Users/nwalls/Documents/vitalsource/one-on-one-notes/sean-mckeever

1to1.rb \
    --date=2026-11-17 \
    --name="Dave Campbell" \
    --output-directory=/Users/nwalls/Documents/vitalsource/one-on-one-notes/dave-campbell
```

I’d like something simpler that saved to the same location. I’m thinking of:

```bash
1to1.rb \
    --date=2026-11-17 \
    --name="Dave Campbell"
```

Review the current code and suggest a change to the existing script.

### Iter. 1a

The suggestions look good. Go ahead and implement them. Use `$HOME/Documents/vitalsource/one-to-one-notes` as the base directory.

## Iter. 2

Next, instead of writing new files into flat directories, write them into the base path, the converted name directory, then new folders for the current year and month in ISO 8601 format. For example: `$HOME/Documents/vitalsource/one-on-one-notes/dave-campbell/20206/11`.

### Iter. 2a

Two adjustments:

- The file should save to the following path: `~/Documents/vitalsource/one-to-one-notes/dave-campbell/2026/11/2026-11-17-dave-campbell.md`
- When the output path is specified with a year and month, use that. Otherwise, fill it in.

## Iter. 3

Next, I need to cleanup `$HOME/Documents/vitalsource/one-on-one-notes` with a new Ruby script.

For each subdirectory within the base path:

- Find files starting with an ISO-8601 date and ending with a `.md` extension.
- Parse the year and month for the file.
- Create a year and month subdirectory, if it doesn’t exist.
- Move the file into the new directory path.

For example:

`/Users/nwalls/Documents/vitalsource/one-on-one-notes/well-ronfim/2026-11-04-well-ronfim.md` would move to `/Users/nwalls/Documents/vitalsource/one-on-one-notes/well-ronfim/2026/11/2026-11-04-well-ronfim.md`

I’m starting with one-on-one-notes, but there will be other file paths I use this utility with. Expect some sort of path argument into the script. It can be `--path`, `-p`, or provided as the first argument.
