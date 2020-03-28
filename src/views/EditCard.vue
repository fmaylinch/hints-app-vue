<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>{{title}}</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn v-if="isEditing" icon><v-icon>mdi-delete</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <div>Card will be edited here: {{ cardForm.hints }}</div>
        <div>{{cards.length}} cards total</div>
      </v-card>
    </v-content>
  </div>
</template>

<script>
export default {
  props: {
    card: Object, // route params that comes as props thanks to configuration in routes
    cards: { type: Array, required: true }
  },
  data: () => ({
    cardForm: null
  }),
  created() {
    // Note that we pass an object to params, the card won't be available if page is reloaded.
    // It will then think that we are going to create a new card. See computed title.
    console.log("card", this.card);
    if (this.card) {
      this.cardForm = {
        hints: this.card.hints.join("\n"),
        score: this.card.score,
        notes: this.card.notes,
        tags: this.card.tags.join(" ")
      };
    } else {
      this.cardForm = {
        hints: "",
        score: 50,
        notes: "",
        tags: ""
      };
    }
  },
  computed: {
    isEditing: function() {
      return this.card != null;
    },
    title: function() {
      return this.isEditing ? "Edit Card" : "Create Card";
    }
  }
};
</script>
