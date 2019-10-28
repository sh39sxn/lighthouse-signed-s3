# lighthouse-signed-s3
This repo contains scripts and a Dockerfile for calculating Googles Lighthouse score, save the results at a signed S3 URL. Optionally there is an example of a GitLab CI/CD Job showing how to integrate the container in your CI/CD pipeline.

## Getting Started

Instructions how to use this project can be found on my blog [https://allaboutaws.com/how-to-save-googles-lighthouse-score-at-presigned-s3-urls-and-proceed-abort-gitlab-ci-cd-pipeline-accordingly](https://allaboutaws.com/how-to-save-googles-lighthouse-score-at-presigned-s3-urls-and-proceed-abort-gitlab-ci-cd-pipeline-accordingly)

### Prerequisites

You need the following setup:

```
Docker (tested Docker version 18.03.0-ce, build 0520e24)
```

### Installing


clone this project:

```
git clone https://github.com/sh39sxn/lighthouse-signed-s3.git
```


Build the Docker container (or use the prebuild one at my DockerHub Repo [https://hub.docker.com/r/sh39sxn/lighthouse-signed-s3](https://hub.docker.com/r/sh39sxn/lighthouse-signed-s3)):
```
cd lighthouse-signed-s3
docker build -t sh39sxn/lighthouse-signed-s3:latest -f ./Dockerfile .
```

Run the Docker container (adjust the environment variables before, see my blog post for complete list of available environment variables):
```
docker run -it -v /tmp:/tmp/lighthouse_score -e URL=https://allaboutaws.com sh39sxn/lighthouse-signed-s3:latest
```




## Donation
Thank's for any donations if you like this project!

Litecoin address: LdxTMGSUGLWfcULQQ6UWTNcJGGCLysefJ7

Bitcoin address: 1H7GZ2SGQcDiEcbqdimn2C9AM4VGbqrBdx

Ethereum address: 0x2a427da268c081466be59b41e0a7ad556f57e755

## Built With

* [Docker](https://www.docker.com/)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details