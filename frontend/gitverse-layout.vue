<script setup>

import { Disclosure, DisclosureButton, DisclosurePanel, Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { Bars3Icon, BellIcon, XMarkIcon } from '@heroicons/vue/24/outline'

const { isShowNewForm, toggleShowNewForm, updateList } = $(gvStore())

const user = {
  name: 'Tom Cook',
  email: 'tom@example.com',
  imageUrl:
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
}
const navigation = [
  { name: 'Dashboard', href: '/', current: true },
  { name: 'Team', href: '#', current: false },
  { name: 'Projects', href: '#', current: false },
  { name: 'Calendar', href: '#', current: false },
  { name: 'Reports', href: '#', current: false },
]
const userNavigation = [
  { name: 'Your Profile', href: '#' },
  { name: 'Settings', href: '#' },
  { name: 'Sign out', href: '#' },
]
</script>

<template>
  <div class="min-h-full">
    <div class="bg-gray-800 pb-32">
      <Disclosure v-slot="{ open }" as="nav" class="bg-gray-800">
        <div class="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div class="border-b border-gray-700">
            <div class="flex h-16 px-4 items-center justify-between sm:px-0">
              <div class="flex items-center">
                <div class="font-extrabold flex-shrink-0 text-white text-3xl">
                  GitVerse
                </div>
                <div class="hidden md:block">
                  <div class="flex space-x-4 ml-10 items-baseline">
                    <a v-for="item in navigation" :key="item.name" :href="item.href" :class="[item.current ? 'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white', 'px-3 py-2 rounded-md text-sm font-medium']" :aria-current="item.current ? 'page' : undefined">{{ item.name }}</a>
                  </div>
                </div>
              </div>
              <div class="hidden md:block">
                <div class="flex ml-4 items-center md:ml-6">
                  <button type="button" class="rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-white focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800">
                    <span class="sr-only">View notifications</span>
                    <BellIcon class="h-6 w-6" aria-hidden="true" />
                  </button>

                  <ProfileDropdownOrLogin />
                </div>
              </div>
              <div class="flex -mr-2 md:hidden">
                <!-- Mobile menu button -->
                <DisclosureButton class="rounded-md bg-gray-800 p-2 text-gray-400 inline-flex items-center justify-center hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-white focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800">
                  <span class="sr-only">Open main menu</span>
                  <Bars3Icon v-if="!open" class="h-6 w-6 block" aria-hidden="true" />
                  <XMarkIcon v-else class="h-6 w-6 block" aria-hidden="true" />
                </DisclosureButton>
              </div>
            </div>
          </div>
        </div>

        <DisclosurePanel class="border-b border-gray-700 md:hidden">
          <div class="space-y-1 py-3 px-2 sm:px-3">
            <DisclosureButton v-for="item in navigation" :key="item.name" as="a" :href="item.href" :class="[item.current ? 'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white', 'block px-3 py-2 rounded-md text-base font-medium']" :aria-current="item.current ? 'page' : undefined">
              {{ item.name }}
            </DisclosureButton>
          </div>
          <div class="border-t border-gray-700 pt-4 pb-3">
            <div class="flex px-5 items-center">
              <div class="flex-shrink-0">
                <img class="rounded-full h-10 w-10" :src="user.imageUrl" alt="">
              </div>
              <div class="ml-3">
                <div class="font-medium text-base text-white leading-none">
                  {{ user.name }}
                </div>
                <div class="font-medium text-sm leading-none text-gray-400">
                  {{ user.email }}
                </div>
              </div>
              <button type="button" class="rounded-full ml-auto bg-gray-800 flex-shrink-0 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-white focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800">
                <span class="sr-only">View notifications</span>
                <BellIcon class="h-6 w-6" aria-hidden="true" />
              </button>
            </div>
            <div class="space-y-1 mt-3 px-2">
              <DisclosureButton v-for="item in userNavigation" :key="item.name" as="a" :href="item.href" class="rounded-md font-medium text-base py-2 px-3 text-gray-400 block hover:bg-gray-700 hover:text-white">
                {{ item.name }}
              </DisclosureButton>
            </div>
          </div>
        </DisclosurePanel>
      </Disclosure>
      <header class="py-10">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <h1 class="flex font-bold text-white tracking-tight text-3xl  items-center">
            Dashboard
            <btn-green class="ml-2" @click="toggleShowNewForm">
              Add new pkg
            </btn-green>
          </h1>
        </div>
      </header>
    </div>

    <main class="-mt-32">
      <div class="mx-auto max-w-7xl px-4 pb-12 sm:px-6 lg:px-8">
        <div class="bg-white rounded-lg shadow py-6 px-5 sm:px-6">
          <router-view />
        </div>
      </div>
    </main>
    <NotificationDefault />
    <LoginModal />
    <OnboardModal />
    <ChainSwitchModal />
    <InviteModal />

    <GvModalNewProject />
  </div>
</template>
