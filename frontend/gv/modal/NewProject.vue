<script setup lang="ts">
const { isShowNewForm, form, toggleShowNewForm, updateList } = $(gvStore())
const { storeJson } = $(useNFTStorage())
const { initContract, parseEther, walletAddress } = $(web3AuthStore())
const { addSuccess } = $(notificationStore())

const doSubmitNewForm = async() => {
  if (form.isLoading) return
  form.isLoading = true
  const deps = {
    0: '1.0.0',
    1: '2.0.0',
    2: '1.2.3',
  }

  const metadata = {
    name: form.name,
    description: form.description,
    image: form.image,
    properties: {
      deps,
      owner: walletAddress,
      version: form.version,
      packageHash: form.packageHash,
    },
  }
  const CID = await storeJson(metadata)
  // const CID = 'ipfs://bafkreicdaboewfoejf4pdcvdbjjk4iejr3rqhqi5wdyarzvwekxaitimou'
  const pkgInfoArr = [
    form.name,
    form.version,
    form.description,
    CID,
  ]
  if (form.isEdit)
    pkgInfoArr.push(form.tokenId)

  const depsTokenIds = [0, 1, 2]
  const depsVersions = ['1.0.0', '2.0.0', '1.2.3']

  const contractWriter = await initContract('GitVerse', true)
  const value = parseEther('0.0001')
  const tx = await contractWriter.upsertPkg(pkgInfoArr, depsTokenIds, depsVersions, { value })
  await tx.wait()

  await updateList()
  addSuccess('Submit success')
  toggleShowNewForm()
  setTimeout(() => {
    form.isLoading = false
    form.isEdit = false
    form.image = ''
    form.name = ''
    form.description = ''
    form.version = ''
    form.packageHash = ''
    form.tokenId = ''
  }, 1000)
}

</script>
<template>
  <DialogWide :show="isShowNewForm" @close="toggleShowNewForm">
    <div v-if="form.isLoading">
      <Loading />
    </div>
    <div v-else class="divide-y space-y-8 divide-gray-200">
      <div class="divide-y space-y-8 divide-gray-200 sm:space-y-5">
        <div class="space-y-6 pt-8 sm:space-y-5 sm:pt-10">
          <div v-if="form.isEdit">
            <h3 class="font-medium text-lg text-gray-900 leading-6">
              Edit package {{ form.name }}
            </h3>
            <p class="mt-1 text-sm max-w-2xl text-gray-500">
              Update your package information here
            </p>
          </div>
          <div v-else>
            <h3 class="font-medium text-lg text-gray-900 leading-6">
              Create new package
            </h3>
            <p class="mt-1 text-sm max-w-2xl text-gray-500">
              To create new package you need to input these fields.
            </p>
          </div>
          <div class="min-w-lg space-y-6 sm:space-y-5">
            <div class="rounded-lg overflow-hidden">
              <FileUploaderBanner v-model="form.image" class="max-w-lg" />
            </div>

            <div class="sm:border-t sm:border-gray-200 sm:grid sm:pt-5 sm:gap-4 sm:grid-cols-3 sm:items-start">
              <label for="packageName" class="font-medium text-sm text-gray-700 block sm:mt-px sm:pt-2">Package Name</label>
              <div class="mt-1 sm:mt-0 sm:col-span-2">
                <input id="packageName" v-model="form.name" type="text" name="packageName" autocomplete="packageName" class="rounded-md  border-gray-300 shadow-sm w-full  sm:text-sm focus:border-indigo-500 focus:ring-indigo-500">
              </div>
            </div>

            <div class="sm:border-t sm:border-gray-200 sm:grid sm:pt-5 sm:gap-4 sm:grid-cols-3 sm:items-start">
              <label for="description" class="font-medium text-sm text-gray-700 block sm:mt-px sm:pt-2">Description</label>
              <div class="mt-1 sm:mt-0 sm:col-span-2">
                <textarea id="description" v-model="form.description" name="description" rows="3" class="rounded-md border-gray-300 shadow-sm w-full p-4 sm:text-sm focus:border-indigo-500 focus:ring-indigo-500" />
              </div>
            </div>

            <div class="sm:border-t sm:border-gray-200 sm:grid sm:pt-5 sm:gap-4 sm:grid-cols-3 sm:items-start">
              <label for="version" class="font-medium text-sm text-gray-700 block sm:mt-px sm:pt-2">Version</label>
              <div class="mt-1 sm:mt-0 sm:col-span-2">
                <input id="version" v-model="form.version" type="text" name="version" autocomplete="version" class="rounded-md max-w-lg border-gray-300 shadow-sm w-full block  sm:text-sm focus:border-indigo-500 focus:ring-indigo-500">
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="pt-5">
        <div class="flex justify-end">
          <btn-plain @click="toggleShowNewForm">
            Cancel
          </btn-plain>
          <btn-black class="ml-3" :is-loading="form.isLoading" @click="doSubmitNewForm">
            Submit
          </btn-black>
        </div>
      </div>
    </div>
  </DialogWide>
</template>
