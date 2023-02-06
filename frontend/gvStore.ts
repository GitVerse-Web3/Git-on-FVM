export const gvStore = defineStore('gvStore', () => {
  const { initContract, walletAddress } = $(web3AuthStore())
  const { getJson, getStatus } = $(useNFTStorage())

  let isShowNewForm = $ref(false)
  let isListLoading = $ref(true)
  const form = $ref({
    isEdit: false,
    isLoading: false,
    name: '',
    image: '',
    description: '',
    version: '',
    packageHash: '',
    tokenId: '',
  })
  let items = $ref([])

  const toggleShowNewForm = () => {
    isShowNewForm = !isShowNewForm
    if (!isShowNewForm) {
      form.isEdit = false
      form.isLoading = false
      form.name = ''
      form.image = ''
      form.description = ''
      form.version = ''
      form.packageHash = ''
    }
  }
  const updateList = async() => {
    isListLoading = true
    const contractReader = await initContract('GitVerse')
    const allToken = await contractReader.getList(0, 100)
    if (!allToken.tokenURIs) return
    const _items = []
    await Promise.all(allToken.tokenURIs.map(async(tokenURI, tokenId) => {
      const data = await getJson(tokenURI)
      const status = await getStatus(tokenURI)
      _items.push({
        ...data,
        status,
        tokenId,
        tokenURI,
        depsCount: allToken.depsCounts[tokenId],
        totalSupply: allToken.totalSupplys[tokenId],
      })
    }))
    items = reverse(_items.sort(item => item.tokenId))

    isListLoading = false
  }

  const isOwner = (item) => {
    const owner = get(item, 'properties.owner', false)
    if (!owner) return false

    return owner === walletAddress
  }

  const showEdit = (item) => {
    form.isEdit = true
    form.tokenId = item.tokenId
    form.name = item.name
    form.image = item.image
    form.description = item.description
    form.version = get(item, 'properties.version')
    form.packageHash = get(item, 'properties.packageHash')
    toggleShowNewForm()
  }

  watchEffect(async() => {
    if (!walletAddress) return
    // do some init stuff
    await updateList()
  })

  return $$({
    isListLoading,
    isShowNewForm,
    form,
    items,
    showEdit,
    isOwner,
    toggleShowNewForm,
    updateList,
  })
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(gvStore, import.meta.hot))
