<template>
  <v-app>
    <transition>
      <keep-alive include="Home">
        <!-- We could pass props to all the views -->
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
