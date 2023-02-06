# Git on FVM

## Our Solution

Programmable code-NFTs - addressing the value and incentives of open source projects
Decentralized code hosting - trusted computing and storage
Web3 open source Copyright license - copyright traceability of open source projects
Programmable code-NFTs
Core Logic
Gitverse supports open-source projects to mint programmable NFTs to realize project copyright tracking, value accumulation, and developer ecological incentives.

## Smart Contract Design

1.How to express dependencies between projects
Example: Project A depends on project B and project C, and projects A, B, and C correspond to contracts ERC1155-A, ERC1155-B, and ERC1155-C respectively (of course, the project is not limited to ERC1155, and the project can also be ERC721, ERC3525) Solution: There is a mapping in the contract ERC1155-A, indicating the dependency (array or mapping) corresponding to the current version (tokenID), and the token address of the element ERC1155-B and ERC1155-C exists in the dependency array, and the elements in the array cannot be repeated.
If the dependency is removed (for example, the current version no longer depends on project A), the token address in the dependency array needs to be deleted synchronously
2.How to express the iteration of the project (the growth of the project)
Problem: Each project will have iterations of versions, and each iteration will be different. Solution: You can regard a project as a collection, and each project has different versions, which correspond to the tokenId of the collection. It's just that the collection does not set the total supply of tokenId (in fact, it is determined by the upper limit of uint256)

## Value

Programmable code-NFTs can dynamically record the copyright of open source projects (ownership/compliance with project dependencies under open source agreements)
Programmable code-NFTs can be used for developer incentives in the open source ecosystem, and identity authentication for developers and users
The release logic of programmable code-NFTs greatly reduces the risk of over-release in the early stage of the project, and the value grows with the growth of the project itself (version update, developer ecology, project dependency)
Decentralized code hosting
Gitverse command-line
Gitverse supports the command line

gitverse init Create a gitverse code warehouse in the current directory, and create a smart contract based on the repository name;
gitverse add <pathlist...> Add the specified file or directory to the gitverse code staging area
gitverse tag <tagName> Create a new tag, and push all the code of the tag to the gitverse code warehouse at the same time.
gitverse commit -m comments Submit the code in the temporary storage area to the gitverse warehouse area. Currently, all codes are uploaded to the gitverse code warehouse based on the commitId point, and later optimized to only upload the code that is different from the previous commitId.
Value
Cheap. Distributed storage space is not provided by service providers, but by nodes connected to the network, which is very cheap as a private warehouse.
high speed. Distributed storage naturally has the function of CDN acceleration.
Data security and traceability. When the system detects that the file is lost, it will automatically recover and resist DDOS, and the data can be traced back.

## How it works

How Ecosystem Works
Technical Architecture
How it's Made
Project A depends on project B and project C, and projects A, B, and C correspond to contracts ERC1155-A, ERC1155-B, and ERC1155-C respectively (of course, the project is not limited to ERC1155, and the project can also be ERC721, ERC3525) Solution: There is a mapping in the contract ERC1155-A, indicating the dependency (array or mapping) corresponding to the current version (tokenID), and the token address of the element ERC1155-B and ERC1155-C exists in the dependency array, and the elements in the array cannot be repeated.
