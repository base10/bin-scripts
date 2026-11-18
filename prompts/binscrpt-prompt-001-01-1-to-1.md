# binscrpt-prompt-001-01-1-to-1

## Meta

Start date: 2026-11-18
Model: Gemma 4 12B IT QAT Optiq
Session name: ses_binscrpt-prompt-001-01-1-to-1

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
