<template>
  <v-app>
    <transition>
      <!-- https://vuejs.org/v2/api/#keep-alive -->
      <keep-alive include="Home">
        <router-view />
      </keep-alive>
    </transition>
  </v-app>
</template>

<script>
export default {
  name: "App"
};
</script>
