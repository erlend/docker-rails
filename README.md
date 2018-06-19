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

The following build args can be used to change the contents of the final image:

| Argument           | Default          | Description                                        |
| ------------------ | ---------------- | -------------------------------------------------- |
| `RAILS_ENV`        | production       | Rails environment used for `assets:precompile`     |
| `BUNDLER_WITHOUT`  | development:test | Bundler won't install these groups                 |
| `INSTALL_GEMS`     |                  | Space separated list of Ruby gems to install       |
| `INSTALL_PACKAGES` |                  | Space separated list of Alpine packages to install |

### Using foreman

Make sure your `Dockerfile` contains the following:

```Dockerfile
FROM erlend/rails
CMD ["foreman", "start"]
```

Then build the image with the `INSTALL_GEMS` argument.

```sh
docker build -t imagename --build-arg INSTALL_GEMS="foreman" .
```
