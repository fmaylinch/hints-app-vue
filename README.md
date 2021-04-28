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

- Start API server `hints-app-api` and enable CORS
- In `apiUrl` (file `constants.js`) use `http://localhost:8090/` or the computer IP if you want access from mobile
- `npm run serve`
- http://localhost:8080

## Deployment

- Set `apiUrl = ""` (file `constants.js`)
- `npm run build`
- Copy `dist` folder contents to `resources` of `hints_app_api` project
- Run `deploy.sh` from `hints_app_api` project

## Other

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
