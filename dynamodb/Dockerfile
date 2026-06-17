FROM amazon/aws-cli:latest

COPY . /seeder
WORKDIR /seeder

ENTRYPOINT ["/bin/bash", "importer.sh"]
