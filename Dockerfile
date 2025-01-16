FROM snakemake/snakemake:latest

# LABEL org.opencontainers.image.authors="Johannes Köster <johannes.koester@tu-dortmund.de>"
ADD . /tmp/repo
WORKDIR /tmp/repo
ENV LANG C.UTF-8
ENV SHELL /bin/bash
USER root 
# working in the right directoy
# this is added in new branch
ENV APT_PKGS bzip2 ca-certificates curl wget gnupg2 squashfs-tools git
RUN ["snakemake","--help"]
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends ${APT_PKGS} \
#     && apt-get clean \
#     && rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log

# RUN micromamba create -q -y -c conda-forge -n apptainer apptainer

# RUN micromamba create -q -y -c bioconda -c conda-forge -n snakemake \
#     snakemake-minimal --only-deps && \
#     eval "$(micromamba shell hook --shell bash)" && \
#     micromamba activate /opt/conda/envs/snakemake && \
#     micromamba install -c conda-forge conda && \
#     micromamba clean --all -y

# ENV PATH /opt/conda/envs/snakemake/bin:/opt/conda/envs/apptainer/bin:${PATH}
# RUN ["snakemake","--help"]
# RUN pip install .[reports,messaging,pep]