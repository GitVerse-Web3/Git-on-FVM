<route lang="yaml">
meta:
  layout: gitverse
</route>

<script setup type="ts">
const { toggleShowNewForm, items, isListLoading } = $(gvStore())
</script>

<template>
  <div>
    <Loading v-if="isListLoading" class=" p-40" />
    <Empty v-else-if="items.length === 0" class="my-20" @newBtnClick="toggleShowNewForm">
      New Project
    </Empty>
    <GvItems v-else :items="items" />
  </div>
</template>
