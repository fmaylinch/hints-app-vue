<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>{{ title }}</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn v-if="isEditing" icon><v-icon>mdi-delete</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-container>
          <v-textarea v-model="cardForm.hints" label="Hints" auto-grow rows="1" />
          <v-textarea v-model="cardForm.notes" label="Notes" auto-grow rows="1" />
          <v-slider :color="sliderColor" v-model="cardForm.score" min="0" max="100" />
          <v-text-field v-model="cardForm.tags" label="Tags" auto-grow rows="1" />
        </v-container>
      </v-card>
    </v-content>
  </div>
</template>

<script>
import { EventBus } from '@/event-bus.js';

export default {
  props: {
    card: Object, // route params that comes as props thanks to configuration in routes
    cards: { type: Array, required: true }
  },
  data: () => ({
    cardForm: null
  }),
  computed: {
    sliderColor: function() {
      const score = this.cardForm.score;
      if (score < 10) return "red";
      if (score < 20) return "deep-orange";
      if (score < 30) return "orange";
      if (score < 40) return "amber";
      if (score < 50) return "yellow";
      if (score < 60) return "white";
      if (score < 70) return "blue lighten-2";
      if (score < 80) return "blue";
      if (score < 90) return "teal";
      return "green";
    },
    isEditing: function() {
      return this.card != null;
    },
    title: function() {
      return this.isEditing ? "Edit Card" : "Create Card";
    }
  },
  created() {
    // Note that we pass an object to params, the card won't be available if page is reloaded.
    // It will then think that we are going to create a new card. See computed title.
    console.log("card", this.card);
    this.cardForm = this.cardToForm(this.card);
  },
  beforeRouteLeave(to, from, next) {
    // When going back home, notify the action in the card
    if (from.name === "EditCard" && to.name === "Home") {
      EventBus.$emit("card-updated", this.buildCardUpdate());
    }
    next();
  },
  methods: {
    buildCardUpdate: function() {
      // TODO: decide action: create, update, delete, nothing
      return { action:"xxx", card:this.formToCard(this.cardForm) };
    },
    formToCard: function(cardForm) {
      return {
        id: cardForm.id,
        hints: cardForm.hints.split("\n").map(hint => hint.trim()),
        notes: cardForm.notes,
        score: cardForm.score,
        tags: cardForm.tags.trim().split(/[, ]+/).filter(tag => !!tag)
      };
    },
    cardToForm: function(card) {
      if (card) {
        return {
          id: card.id,
          hints: card.hints.join("\n"),
          score: card.score,
          notes: card.notes,
          tags: card.tags.join(" ")
        };
      } else {
        return {
          id: null,
          hints: "",
          score: 50,
          notes: "",
          tags: ""
        };
      }
    }
  }
};
</script>
