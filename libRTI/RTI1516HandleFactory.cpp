#include "RTI1516HandleFactory.h"


#define DECLARE_HANDLE_FRIEND_CLASS(HandleKind)														\
																									\
    HandleKind HandleKind##Friend::createRTI1516Handle(const certi::Handle & certiHandle)           \
    {																								\
	    HandleKind##Implementation* handleImpl = new HandleKind##Implementation();					\
		handleImpl->setValue(certiHandle);															\
		HandleKind rti1516Handle(handleImpl);														\
		return rti1516Handle;																		\
    }																								\
																									\
	HandleKind HandleKind##Friend::createRTI1516Handle(const rti1516::VariableLengthData & encodedValue)\
    {																								\
		HandleKind rti1516Handle(encodedValue);														\
		return rti1516Handle;																		\
    }																								\
																									\
	certi::Handle HandleKind##Friend::toCertiHandle(const HandleKind & rti1516Handle)               \
    {																								\
		certi::Handle certiHandle;																	\
		if (rti1516Handle.isValid())																\
		{																							\
			const HandleKind##Implementation* handleImpl = rti1516Handle.getImplementation();		\
			certiHandle = handleImpl->getValue();													\
		} else {																					\
			certiHandle = 0;																		\
		}																							\
		return certiHandle;																			\
    }																								\
																									\
	HandleKind##Friend::HandleKind##Friend() {}														\
	HandleKind##Friend::~HandleKind##Friend() {}													\

/* end of DECLARE_HANDLE_FRIEND_CLASS */

namespace rti1516
{

// All of the RTI API's HandleFriend classes are defined 
// by invoking the macro above.
DECLARE_HANDLE_FRIEND_CLASS(FederateHandle)
DECLARE_HANDLE_FRIEND_CLASS(ObjectClassHandle)
DECLARE_HANDLE_FRIEND_CLASS(InteractionClassHandle)
DECLARE_HANDLE_FRIEND_CLASS(ObjectInstanceHandle)
DECLARE_HANDLE_FRIEND_CLASS(AttributeHandle)
DECLARE_HANDLE_FRIEND_CLASS(ParameterHandle)
DECLARE_HANDLE_FRIEND_CLASS(DimensionHandle)
//DECLARE_HANDLE_FRIEND_CLASS(MessageRetractionHandle)
DECLARE_HANDLE_FRIEND_CLASS(RegionHandle)
  
MessageRetractionHandle MessageRetractionHandleFriend::createRTI1516Handle(const certi::Handle & certiHandle, uint64_t serialNr) {
	MessageRetractionHandleImplementation* handleImpl = new MessageRetractionHandleImplementation();														
	handleImpl->setValue(certiHandle);
	handleImpl->setSerialNum(serialNr);
	MessageRetractionHandle rti1516Handle(handleImpl);														
	return rti1516Handle;	
}
MessageRetractionHandle MessageRetractionHandleFriend::createRTI1516Handle(const rti1516::VariableLengthData & encodedValue) {
	MessageRetractionHandle rti1516Handle(encodedValue);														
	return rti1516Handle;	
}
certi::EventRetraction MessageRetractionHandleFriend::createEventRetraction(const rti1516::MessageRetractionHandle & messageRetractionHandle) {
	const MessageRetractionHandleImplementation* handleImpl = messageRetractionHandle.getImplementation();														
	certi::EventRetraction eventRetraction;
	eventRetraction.setSendingFederate( handleImpl->getValue() );
	eventRetraction.setSN( handleImpl->getSerialNum() );
	return eventRetraction;	
}
MessageRetractionHandleFriend::MessageRetractionHandleFriend() {}                                       
MessageRetractionHandleFriend::~MessageRetractionHandleFriend() {}                                      


} 

