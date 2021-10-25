# Docker - Humio Test Environment

Humio has a very nice and simple way of deploying a local cluster for testing/developing packages. You can find the docs [here](https://library.humio.com/stable/docs/installation/containers/docker/) for getting started, and other useful tidbits you might need.

The Humio Docker container already sets the `HUMIO_JVM_ARGS=-Xss2m`, so there is really no need to set this in the `humio.conf` file. The configuration file here is empty, but available in the event that you need to pass in other Humio startup options.

## Project Layout
```bash
├── README.md
├── etc
├── humio.conf
├── mounts
│   ├── data
│   └── kafka-data
└── start_container.sh
```

The `etc`, `mounts/data`, and `mounts/kafka-data` are directories used by the Humio container in order to provide persistent storage.
> If you want to blow away everything and start from scratch, just remove the data in the `mounts` subdirectories:
> `rm -rf mounts/{data,kafka-data}/*`

The `start_container.sh` script is a simple wrapper script that will make it easier for you to manage your Humio container instance. For example, if you are messing around with the `humio.conf` file, changes will require a restart to the container. Simply running this script again will take care of that for you.

## Prerequisites
Ensure Docker is installed according to your OS.

## Usage
To get started, simply run the following command:
```bash
./start_container.sh
```

You can then hit your Humio instance at `localhost:8080` in your browser.
