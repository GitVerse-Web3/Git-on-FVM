<script setup lang="ts">
interface Props {
  items?: Array
}

const {
  items,
} = defineProps<Props>()
const { isOwner, showEdit } = $(gvStore())

</script>

<template>
  <ul role="list" class="grid gap-6 grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
    <li v-for="item in items" :key="item.tokenId" class="divide-y bg-white rounded-lg flex flex-col divide-gray-200 shadow text-center col-span-1 relative group">
      <btn-green v-if="isOwner(item)" class="top-2 right-2 absolute hidden group-hover:flex" @click="showEdit(item)">
        <material-symbols:edit class="mr-1" />
        Edit
      </btn-green>
      <div class="flex flex-col flex-1 p-8">
        <IpfsImg class="rounded-full mx-auto flex-shrink-0 h-32 w-32" :src="item.image" alt="" :has-modal="true" />
        <h3 class="font-medium mt-6 text-sm text-gray-900">
          {{ item.name }} #{{ item.tokenId }}
        </h3>
        <dl class="flex flex-grow flex-col mt-1 justify-between">
          <dt class="sr-only">
            Description
          </dt>
          <dd class="text-sm text-gray-500">
            {{ item.description }}
          </dd>
          <dt class="sr-only">
            Version
          </dt>
          <dd class="mt-3">
            <span class="rounded-full font-medium bg-green-100 text-xs py-1 px-2 text-green-800">{{ item.properties.version || '1.0.0' }}</span>
          </dd>
        </dl>
      </div>
      <div>
        <div class="divide-x flex -mt-px divide-gray-200">
          <div class="flex flex-1 w-0">
            <div class="border border-transparent rounded-bl-lg font-medium -mr-px flex-1 text-sm py-4 text-gray-700 w-0 relative inline-flex items-center justify-center hover:text-gray-500">
              <fluent-mdl2:total class="h-5 text-gray-400 w-5" />
              <span class="ml-3">{{ item.totalSupply }}</span>
            </div>
          </div>
          <div class="flex -ml-px flex-1 w-0">
            <div class="border border-transparent rounded-br-lg font-medium flex-1 text-sm py-4 text-gray-700 w-0 relative inline-flex items-center justify-center hover:text-gray-500">
              <mdi:dependency class="h-5 text-gray-400 w-5" />
              <span class="ml-3">{{ item.depsCount }}</span>
            </div>
          </div>
        </div>
      </div>
    </li>
  </ul>
</template>
