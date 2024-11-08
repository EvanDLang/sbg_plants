# Dockerfile from pygeoapi github repo see that for more details
FROM ubuntu:jammy-20240627.1

# Defaults:
# SCRIPT_NAME=/
# CONTAINER_NAME=pygeoapi
# CONTAINER_HOST=0.0.0.0
# CONTAINER_PORT=80
# WSGI_WORKERS=4
# WSGI_WORKER_TIMEOUT=6000
# WSGI_WORKER_CLASS=gevent

# ARGS
ARG TZ="Etc/UTC"
ARG LANG="en_US.UTF-8"
ARG ADD_DEB_PACKAGES="\
    libsqlite3-mod-spatialite \
    python3-dask \
    python3-elasticsearch \
    python3-fiona \
    python3-gdal \
    python3-jsonpatch \
    python3-netcdf4 \
    python3-pandas \
    python3-psycopg2 \
    python3-pymongo \
    python3-pyproj \
    python3-rasterio \
    python3-scipy \
    python3-shapely \
    python3-tinydb \
    python3-xarray \
    python3-zarr \
    python3-mapscript \
    python3-pytest \
    python3-pyld"

# ENV settings
ENV TZ=${TZ} \
    LANG=${LANG} \
    DEBIAN_FRONTEND="noninteractive" \
    DEB_BUILD_DEPS="\
    software-properties-common \
    curl \
    unzip" \
    DEB_PACKAGES="\
    locales \
    tzdata \
    gunicorn \
    python3-dateutil \
    python3-gevent \
    python3-greenlet \
    python3-pip \
    python3-tz \
    python3-unicodecsv \
    python3-yaml \
    ${ADD_DEB_PACKAGES}"

WORKDIR /pygeoapi

# Install operating system dependencies
RUN \
    apt-get update -y \
    && apt-get install -y ${DEB_BUILD_DEPS} \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
    && apt-get --no-install-recommends install -y ${DEB_PACKAGES} \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && echo "For ${TZ} date=$(date)" && echo "Locale=$(locale)"  \
    # OGC schemas local setup
    && mkdir /schemas.opengis.net \
    && curl -O http://schemas.opengis.net/SCHEMAS_OPENGIS_NET.zip \
    && unzip ./SCHEMAS_OPENGIS_NET.zip "ogcapi/*" -d /schemas.opengis.net \
    && rm -f ./SCHEMAS_OPENGIS_NET.zip \
    # Cleanup TODO: remove unused Locales and TZs
    # NOTE: this tries to remove gcc, but the actual package gcc-11 can't be
    #       removed because python3-scipy depends on python3-pythran which
    #       depends on g++
    && apt-get remove --purge -y gcc ${DEB_BUILD_DEPS} \
    && apt-get clean \
    && apt autoremove -y  \
    && rm -rf /var/lib/apt/lists/*

ADD requirements-docker.txt requirements-admin.txt /pygeoapi/
# Install remaining pygeoapi deps
RUN python3 -m pip install --no-cache-dir -r requirements-docker.txt \
    && python3 -m pip install --no-cache-dir -r requirements-admin.txt


# ADD . /pygeoapi

 # Install pygeoapi
#RUN python3 -m pip install --no-cache-dir -e . 
RUN python3 -m pip install --no-cache-dir -e git+https://github.com/geopython/pygeoapi.git#egg=pygeoapi
ENV CONTAINER_PORT=5000
COPY entrypoint.sh /entrypoint.sh 
COPY pygeoapi-config.yml /pygeoapi/local.config.yml
# RUN \ 
#     # Set default config and entrypoint for Docker Image
#     cp /pygeoapi/docker/default.config.yml /pygeoapi/local.config.yml \
#     && cp /pygeoapi/docker/entrypoint.sh /entrypoint.sh 

ENTRYPOINT ["/entrypoint.sh"]

#update containter port to match exposed port in ECS service
