# Using containers

## Using Podman

In the open source community [podman](https://podman.io/) takes the place of [docker](https://www.docker.com/) for the creation of application containers. It mimics the commercial software to allow developers work with both tools *almost* interchangeably. It is not uncommon to find people creating aliases of `docker` in their sandbox environments to point to their `podman` executable (some Linux distributions even have packages dedicated to this automatic override). One must be aware that although the command interfaces are very similar, they are not the *exactly* same and advance usage requires mastering each of them individually.

The following summarizes some daily life commands with `podman`.

- List available images in a local machine:

```bash
podman images
```

- Run image `<img>` interactively using bash:

```bash
podman run -it '<img>' /bin/bash
```

- Run image exposing port `<container>` to host at `<host>`:

```bash
podman run -p '<container>:<host>' '<img>'
```

- Dump image `<img>` to `<img>.tar` for portability:

```bash
podman save -o '<img>.tar' '<img>'
```

- List all available containers (there might be external/hidden, so use `-a`):

```bash
podman container ls -a
```

- Remove a given container by ID (only the first 2-3 characters of ID are required):

```bash
podman container rm '<ID>'
```

- Remove a given image by ID:

```bash
podman rmi '<ID>'
# podman image rm '<ID>'
```

## Using Apptainer

Using `podman` locally is great, but packaging redistributable containers for reuse in HPC is much smoother with [Apptainer](https://apptainer.org/). The tool started at [Lawrence Berkeley National Laboratory](https://www.lbl.gov/) can be [downloaded](https://github.com/apptainer/apptainer/releases) for several Linux systems and deployed locally.

Under Debian (or its variants, as Ubuntu), navigate to the download directory and install with the following, taking care to replace the right version:

```shell
export APPTAINER_VERSION=1.3.6_amd64.deb

sudo dpkg -i apptainer_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-dbgsym_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-suid_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-suid-dbgsym_${APPTAINER_VERSION}
```

- Converting a local `podman` *tar-dump* into a Singularity image:

```bash
apptainer build "<img>.sif" "docker-archive://<img>.tar"
```

- Running an `apptainer` image as a non-root user is as simple as:

```bash
apptainer run '<img>.sif'
```

Although Apptainer has its own image scripting system through [*definition files*](https://apptainer.org/docs/user/latest/definition_files.html), personal experience has shown that the workflow is much smoother by generating container files and then converting them to Singularity format as explained above.

There reason is that container files generate intermediate check-points from which they will continue the build if some failure is encountered, *i.e.* each `RUN` command in a container will generate a partial image.

When working with Apptainer definition files, failures imply full rebuild of the image, what might become extremely boring when trying to compile new code. A workaround is to use a sequence of definition files, one importing from the dump of the previous one, but that not only will generate a large size of temporary dumps as it will become difficult to manage.

After getting excited by the Apptainer definition files because they do not need chaining of commands with a `&& \` to make a shell block, I personally gave up on them after loosing a few days of my life recompiling again and again... so for now I stick with the container creation and conversion workflow discussed in more detail below.

Another option with Apptainer is to run instances on the background, as follows:

```bash
apptainer instance start -B $PWD '<file-name>.sif' '<instance-name>'
apptainer shell 'instance://<instance-name>'
```

Other useful/relevant commands in this context are `apptainer instance list` and `apptainer instance stop <instance-name> `.

## Apptainer and environment

Since `apptainer` makes use of *user space*, sourcing of applications is not done as root, so one must edit add to their `~/.bashrc` if path configuration is desired and re-source that file when activating a container. For instance, the required environment variables for #OpenFOAM are provided `FOAM_SOURCE` file given below; in the *host system* outside the container it does not exist, so adding a test in `~/.bashrc` is required. Once you activate the container with `apptainer run <image-name>.sif`, by calling `source ~/.bashrc` the environment will be properly set.

```bash
FOAM_SOURCE=/opt/openfoam12/OpenFOAM-12/etc/bashrc

[[ -f ${FOAM_SOURCE} ]] && source ${FOAM_SOURCE}
```

Another approach is to execute the SIF image once, source the required variables required in the container, dump `env > draft.env`, [edit the file](https://github.com/wallytutor/learning-by-teaching/blob/main/containers/clean-env.py) as required and then wrap a call with contextualized environment as:

```bash
function openfoam12() {
    FOAM_NAME=$HOME/Applications/openfoam12-rockylinux9
    apptainer run --cleanenv --env-file ${FOAM}.env ${FOAM}.sif
}
```

## Build workflow

Using both tools can be roughly automated by generating a `podman` image, dumping it into a portable format, then converting to Singularity format. Below we illustrate the workflow for an arbitrary container file:

```bash
# Set project name:
project="project"

# Ensure a fresh start:
[[ -f "${project}.tar" ]] && rm -rf "${project}.tar"
[[ -f "${project}.sif" ]] && rm -rf "${project}.sif"

# Configure path to applications:
PODMAN=/usr/bin/podman
APPTAINER=/usr/bin/apptainer

# Avoid the following warning:  WARN[0000] "/" is not a shared mount, this
# could cause issues or missing mounts with rootless containers.
# sudo mount --make-rshared /

# Build the container image:
"${PODMAN}" build -t "${project}" -f "Containerfile" .

# Dump container to portable .tar file:
"${PODMAN}" save -o "${project}.tar" "localhost/${project}"

# Convert container into apptainer:
"${APPTAINER}" build "${project}.sif" "docker-archive://${project}.tar"

# Remove tar-file:
rm -rf "${project}.tar"

# After making sure it is working, remove the image (do not automate!):
# "${PODMAN}" rmi "${project}"
```

Now you can move the SIF image to another computer (for instance, you prepared this in a PC with access to the Internet to later use it in an isolated HPC), open a new terminal or `source ~/.bashrc` and run:

```bash
apptainer run -B $PWD '/path/to/project/image.sif'
```

Notice that `apptainer` does not resolve symbolic links, so `$PWD` above will fail if trying to run from a path that contains a link; navigate to the actual directory containing the project before running the image to get your files visible.

**Note:** use `apptainer run` when you want to execute the container's default application or task; on the other hand, use `apptainer shell` when you need an interactive session to explore or debug the container. For the OpenFOAM example above, both are very similar as no default application is launched, but a shell session itself.
