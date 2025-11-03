# Git version control

## First configuration

Upon connecting for the first time in a computer, remmeber to configure:

```bash
git config --global user.email "walter.dalmazsilva@gmail.com"
git config --global user.name "Walter Dal'Maz Silva"

# (GitHub CLI for Linux optional)
gh auth login
```

## Daily life reminders

```bash
git status

git add *

git commit -m "some message"

git checkout '<branch-name>'

git branch -d '<branch-name>'
```

## Creating gh-pages branch

To create a GitHub pages branch with no history do the following

```bash
git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "fresh and empty gh-pages branch"
git push origin gh-pages
```

## Adding submodules

Generally speaking adding a submodule to a repository should be a simple matter of

```bash
git submodule add 'https://<path>/<to>/<repository>.git'
```

Nonetheless this might fail, especially for large sized repositories; I faced [this issue](https://stackoverflow.com/questions/66366582) which I tried to fix by increasing buffer size as reported in the link. This solved the issue but led me to [another problem](https://stackoverflow.com/questions/59282476) which could be solved by degrading HTTP protocol.

The reverse operation cannot be fully automated as discussed [here](https://stackoverflow.com/questions/1260748). In general you start with

```bash
git rm '<path-to-submodule>'
```

and then manually remove the history with

```bash
rm -rf '.git/modules/<path-to-submodule>'

git config remove-section 'submodule.<path-to-submodule>'
```

## Line ending normalization

Instructions provided in [this thread](https://stackoverflow.com/questions/2517190); do not forget to add a `.gitattributes` file to the project with `* text=auto` for checking-in files as normalized. Then run the following:

```bash
git add --update --renormalize
```

## Other tips

### Version control in Windows

For Windows users, [TortoiseGIT](https://tortoisegit.org/) adds the possibility of managing version control and other features directly from the file explorer.
