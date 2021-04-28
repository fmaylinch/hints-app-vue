<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>Play Card</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn @click="revealCard()" icon><v-icon>mdi-eye</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-container>
          Hint: {{ hint }}
        </v-container>
      </v-card>
    </v-content>
  </div>
</template>

<script>
import {EventBus} from '@/event-bus.js';

export default {
  props: {
    card: Object // route params that comes as props thanks to configuration in routes
  },
  data: () => ({
    hint: ""
  }),
  created() {
    console.log("Playing card:", this.card);
    const hintIndex = Math.floor(Math.random() * this.card.hints.length);
    this.hint = this.card.hints[hintIndex];
  },
  methods: {
    revealCard() {
      EventBus.$emit("card-played", {card: this.card});
      this.$router.go(-1); // go back to CardList
    }
  }
};
</script>
