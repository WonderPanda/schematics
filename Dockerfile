FROM node:carbon-alpine as builder
WORKDIR /nestjs/schematics
COPY . .
RUN npm install && \
    rm -rf schematics && mkdir schematics && \
    npm run -s build && \
    cp -R src/* schematics && \
    cp -R LICENSE package.json package-lock.json README.md schematics

FROM node:carbon-alpine
WORKDIR /nestjs/schematics
RUN npm install -g @angular-devkit/schematics-cli
COPY --from=builder /nestjs/schematics/schematics .
RUN npm install --production && npm link
WORKDIR /workspace
VOLUME [ "/workspace" ]
CMD [ "/bin/sh" ]