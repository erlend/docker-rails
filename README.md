# Rails

Easy solution for creating a Docker image from a [Ruby on Rails](https://rubyonrails.org) app.

## Getting Started

Create a `Dockerfile` in your Rails project's path containing the following:

```Dockerfile
FROM erlend/rails
```

That's pretty much it for most applications. Now you can create the image with:

```sh
docker build -t imagename .
```

## Additional configuration

The following options can be set with the `--build-arg` argument when running `docker build`.

| Argument         | Default          | Description                              |
| ---------------- | ---------------- | ---------------------------------------- |
| `RAILS_ENV`      | production       | Environment used for `assets:precompile` |
| `BUNDLE_WITHOUT` | development:test | Bundler won't install these groups       |

## Examples

### Using foreman

Make sure your `Dockerfile` contains the following:

```Dockerfile
FROM erlend/rails
RUN gem install foreman -N
CMD ["foreman", "start"]
```

### Creating a image for a different environment

You'll need to set the `RAILS_ENV` variable in your `Dockerfile` and pass it
 as `build-arg` when building. The `BUNDLE_WITHOUT` argument will probably need
to be set too.

The `Dockerfile` following would build a image for the test environment:

```Dockerfile
FROM erlend/rails
ENV RAILS_ENV=test
```

Then build it with:
```sh
docker build . \
         -t imagename \
         --build-arg RAILS_ENV=test \
         --build-arg BUNDLE_WITHOUT="development:production"
```
