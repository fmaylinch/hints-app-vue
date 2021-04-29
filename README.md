# Hints App client with Vue

- I created this project with the [CLI].
- I followed the instructions in this [video about CLI].


[CLI]: https://vuejs.org/v2/guide/installation.html#CLI
[video about CLI]: https://www.vuemastery.com/courses/real-world-vue-js/vue-cli/


## Project setup
```
npm install
```

## Development

- Start API server `hints-app-api`
    - Note that `constants.js` points to the server
    - Check that CORS is enabled in server 
- `npm run serve`
- http://localhost:8080

## Deployment

- `npm run build`
- `./copy-dist.sh` to copy `dist` folder to `hints_app_api` project
- Run `deploy.sh` from `hints_app_api` project

## Other

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
