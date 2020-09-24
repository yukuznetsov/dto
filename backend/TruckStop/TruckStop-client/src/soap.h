#include "soapH.h"
#include "soapStub.h"

#ifndef   TRUCKSTOP_CLIENT__SOAP_H
#  define TRUCKSTOP_CLIENT__SOAP_H

#include <cstddef>
///#include <exception>

/// Common classes
typedef  web__ReturnBase                               ReturnBase;

//class Errors
//{
//public:
//	template <typename T>
//	ReturnBase *operator=(T *ptr)
//	{
//#ifdef USE_INHERITANCE
//		return ptr->errors();
//#else
//		return errors(ptr);
//#endif
//	}
//};

/// LoadSearch interface
namespace LS
{

/// Response classes (derived from ReturnBase aka web__ReturnBase)
#ifdef USE_INHERITANCE
/// Call member-fn errors() of corresponded response class to refer service's
/// error list
struct LoadSearchResultsResponse : _lssvc__GetLoadSearchResultsResponse
{
	ReturnBase *errors() const { return GetLoadSearchResultsResult; }
};
struct LoadSearchDetailResultResponse : _lssvc__GetLoadSearchDetailResultResponse
{
	ReturnBase *errors() const { return GetLoadSearchDetailResultResult; }
};
struct MultipleLoadDetailResultsResponse : _lssvc__GetMultipleLoadDetailResultsResponse
{
	ReturnBase *errors() const { return GetMultipleLoadDetailResultsResult; }
};
#else
/// ----
typedef  _lssvc__GetLoadSearchResultsResponse          LoadSearchResultsResponse;
typedef  _lssvc__GetLoadSearchDetailResultResponse     LoadSearchDetailResultResponse;
typedef  _lssvc__GetMultipleLoadDetailResultsResponse  MultipleLoadDetailResultsResponse;
#endif

/// GetLoadSearchResults procedure

typedef  _lssvc__GetLoadSearchResults                  LoadSearchResults;
typedef  web1__LoadSearchRequest                       LoadSearchRequest;
typedef  web1__LoadSearchCriteria                      LoadSearchCriteria;
typedef  truc__LoadType                                LoadType;
typedef  arr__ArrayOfdateTime                          ArrayOfdateTime;
typedef  truc__ArrayOfTrailerOptionType                ArrayOfTrailerOptionType;
typedef  truc__TrailerOptionType                       TrailerOptionType;
typedef  truc__LoadType                                LoadType;
typedef  web1__SortColumn                              SortColumn;
typedef  objs__LoadSearchReturn                        LoadSearchReturn;
typedef  web__ArrayOfError                             ArrayOfError;
typedef  web__Error                                    Error;
typedef  objs__ArrayOfLoadSearchItem                   ArrayOfLoadSearchItem;
typedef  objs__LoadSearchItem                          LoadSearchItem;

/// GetLoadSearchDetailResult procedure

typedef  _lssvc__GetLoadSearchDetailResult             LoadSearchDetailResult;
typedef  web1__LoadDetailRequest                       LoadDetailRequest;
typedef  objs__LoadDetailResult                        LoadDetailResult;
typedef  objs__LoadDetailReturn                        LoadDetailReturn;

/// GetMultipleLoadDetailResults procedure
///
typedef  _lssvc__GetMultipleLoadDetailResults          MultipleLoadDetailResults;
typedef  objs__MultipleLoadDetailReturn                MultipleLoadDetailReturn;
typedef  truc__EquipmentTypes                          EquipmentTypes;
typedef  truc__TrailerOptionType                       TrailerOptionType;

}

/// RateMate interface
namespace RM
{

/// Common classes
typedef  web__ReturnBase                               ReturnBase;

/// Response classes (derived from ReturnBase aka web__ReturnBase)
#ifdef USE_INHERITANCE
/// Call member-fn errors() of corresponded response class to refer service's
/// error list
struct HistoricalRatesResponse : _rmsvc__GetHistoricalRatesResponse
{
	ReturnBase *errors() const { return GetHistoricalRatesResult; }
};
struct NegotiationStrengthResponse : _rmsvc__GetNegotiationStrengthResponse
{
	ReturnBase *errors() const { return GetNegotiationStrengthResult; }
};
struct FuelSurchargeResponse : _rmsvc__GetFuelSurchargeResponse
{
	ReturnBase *errors() const { return GetFuelSurchargeResult; }
};
struct RateIndexResponse : _rmsvc__GetRateIndexResponse
{
	ReturnBase *errors() const { return GetRateIndexResult; }
};
#else
/// ----
typedef  _rmsvc__GetHistoricalRatesResponse            HistoricalRatesResponse;
typedef  _rmsvc__GetNegotiationStrengthResponse        NegotiationStrengthResponse;
typedef  _rmsvc__GetFuelSurchargeResponse              FuelSurchargeResponse;
typedef  _rmsvc__GetRateIndexResponse                  RateIndexResponse;
#endif

typedef  _rmsvc__GetHistoricalRates                    HistoricalRates;
typedef  rate__RateSearchRequest                       RateSearchRequest;
typedef  rate__LaneSearchCriteria                      LaneSearchCriteria;
typedef  rate__RateSearchCriteria                      RateSearchCriteria;

typedef  _rmsvc__GetNegotiationStrength                NegotiationStrength;
typedef  rate__NegotiationStrengthRequest              NegotiationStrengthRequest;

typedef  _rmsvc__GetFuelSurcharge                      FuelSurcharge;
typedef  rate__FuelSurchargeRequest                    FuelSurchargeRequest;

typedef  _rmsvc__GetRateIndex                          RateIndex;
//typedef  rate__RateSearchRequest                       RateSearchRequest;

}

#ifdef USE_INHERITANCE
template <typename T>
ReturnBase *errors(T *ptr)
{
	return ptr->errors();
}
#else
/// Really not implemented,
template <typename T> ReturnBase *base(T *);
/// except for considered classes below
template <>
ReturnBase *base(LS::LoadSearchResultsResponse *res);
template <>
ReturnBase *base(LS::LoadSearchDetailResultResponse *res);
template <>
ReturnBase *base(LS::MultipleLoadDetailResultsResponse *res);
template <>
ReturnBase *base(RM::HistoricalRatesResponse *res);
template <>
ReturnBase *base(RM::NegotiationStrengthResponse *res);
template <>
ReturnBase *base(RM::FuelSurchargeResponse *res);
template <>
ReturnBase *base(RM::RateIndexResponse *res);
#endif

/// Really not implemented,
template <typename T, typename ... Args> void set_result(T *, Args * ... a);
/// except for considered classes below
template <>
void set_result(LS::LoadSearchResults *ret,
				LS::LoadSearchRequest *req);
template <>
void set_result(LS::LoadSearchDetailResult *ret,
				LS::LoadDetailRequest *req);
template <>
void set_result(LS::MultipleLoadDetailResults *ret,
				LS::LoadSearchRequest *req);
template <>
void set_result(RM::HistoricalRates *ret,
				RM::RateSearchRequest *req);
template <>
void set_result(RM::NegotiationStrength *ret,
				RM::NegotiationStrengthRequest *req);
template <>
void set_result(RM::FuelSurchargeRequest *ret,
				RM::LaneSearchCriteria *req1, std::string *req2);
template <>
void set_result(RM::RateSearchRequest *ret,
				RM::LaneSearchCriteria *req1, RM::RateSearchCriteria *req2);

#endif // TRUCKSTOP_CLIENT__SOAP_H
