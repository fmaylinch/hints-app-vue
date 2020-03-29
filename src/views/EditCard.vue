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
import CardUpdateAction from '@/card-update-action.js';
import Util from "@/util.js";

export default {
  props: {
    card: Object // route params that comes as props thanks to configuration in routes
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
      let card = this.formToCard(this.cardForm);
      return {
        action: this.decideAction(card),
        card: card
      };
    },
    decideAction: function(card) {

      if (card.hints.length === 0)
        return CardUpdateAction.nothing;

      if (!this.card)
        return CardUpdateAction.update;

      if (Util.getCardRawContent(card) === Util.getCardRawContent(this.card))
        return CardUpdateAction.nothing;

      return CardUpdateAction.update;
    },
    formToCard: function(cardForm) {
      return {
        id: cardForm.id,
        hints: cardForm.hints.split("\n").map(hint => hint.trim()).filter(it => !!it),
        notes: cardForm.notes,
        score: cardForm.score,
        tags: cardForm.tags.trim().split(/[, ]+/).filter(it => !!it)
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
