#  SeatGeek Sample App

General approach is to follow a Coordinator pattern to avoid  `UIViewController` coupling.


## Coordinator
 
 Provide CRUD interface to Controllers while maintaining state.
 Allow controllers to delegate actions to keep them simple.
 shows the errors.
 *Can integrate with promises to make these flows clearer
 *Can create state machine to make transitions clearer and finite
 
 Interface with Services to provide ViewModels

## Service

Serve Data for specific domain, could provide base objects to generate ViewModels but currently serving ViewModels.
Maintains interface with lower level NetworkService
Provides the errors 


TODOs: 
Progress Indicator
Pagination - Lazy Loading
Pull To Refresh


