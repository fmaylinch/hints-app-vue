<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>Login</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="login()"><v-icon>mdi-login-variant</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-container>
          <v-text-field v-model="loginData.email" label="email" auto-grow rows="1" />
          <v-text-field v-model="loginData.password" label="password" auto-grow rows="1" />
          <v-text-field v-model="loginData.password2" label="repeat password to register" auto-grow rows="1" />
        </v-container>
      </v-card>
    </v-content>
  </div>
</template>

<script>
import {EventBus} from '@/event-bus.js';
import axios from "axios";
import constants from "@/constants";
import Cookies from 'js-cookie'

export default {
  data: () => ({
    loginData: { email: "", password: "", password2: "" }
  }),
  created() {
    console.log("Login");
  },
  methods: {
    login() {
      axios
        .post(constants.apiUrl + "/security/login", this.loginData)
        .then(resp => this.goToCards(resp.data))
        .catch(e => this.handleError(e));
    },
    goToCards(loginResponse) {
      // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
      Cookies.set("jwt", loginResponse.password, { sameSite: "strict" }); // the JWT comes here
      EventBus.$emit("user-logged");
      this.$router.go(-1); // go back to CardList
    },
    handleError(error) {
      console.error("API Error:", error);
    }
  }
};
</script>
