# include "soap.h"

#ifdef  USE_INHERITANCE
template <typename T>
ReturnBase *base(T ptr)
{
	return (&ptr)->errors();
}
#else

/// base

template <>
ReturnBase *base(LS::LoadSearchResultsResponse *res)
{
	return res->GetLoadSearchResultsResult;
}

template <>
ReturnBase *base(LS::LoadSearchDetailResultResponse *res)
{
	return res->GetLoadSearchDetailResultResult;
}

template <>
ReturnBase *base(LS::MultipleLoadDetailResultsResponse *res)
{
	return res->GetMultipleLoadDetailResultsResult;
}

template <>
ReturnBase *base(RM::HistoricalRatesResponse *res)
{
	return res->GetHistoricalRatesResult;
}

template <>
ReturnBase *base(RM::NegotiationStrengthResponse *res)
{
	return res->GetNegotiationStrengthResult;
}

template <>
ReturnBase *base(RM::FuelSurchargeResponse *res)
{
	return res->GetFuelSurchargeResult;
}

template <>
ReturnBase *base(RM::RateIndexResponse *res)
{
	return res->GetRateIndexResult;
}

/// set_result

template <>
void set_result(LS::LoadSearchResults *ret,
				 LS::LoadSearchRequest *req)
{
	ret->searchRequest = req;
}

template <>
void set_result(LS::LoadSearchDetailResult *ret,
				LS::LoadDetailRequest *req)
{
	ret->detailRequest = req;
}

template <>
void set_result(LS::MultipleLoadDetailResults *ret,
				LS::LoadSearchRequest *req)
{
	ret->searchRequest = req;
}

template <>
void set_result(RM::RateSearchRequest *ret,
				RM::LaneSearchCriteria *req1, RM::RateSearchCriteria *req2)
{
	ret->Criteria     = req1;
	ret->RateCriteria = req2;
}

template <>
void set_result(RM::NegotiationStrengthRequest *ret,
				RM::LaneSearchCriteria *req)
{
	ret->Criteria = req;
}

template <>
void set_result(RM::FuelSurchargeRequest *ret,
				RM::LaneSearchCriteria *req1, std::string *req2)
{
	ret->Criteria       = req1;
	ret->MilesPerGallon = req2;
}

#if 1
#warning TODO: Check if it could be removed!
#else
template <>
void set_result(RM::RateSearchRequest *ret,
				RM::LaneSearchCriteria *req1, RM::RateSearchCriteria *req2)
{
	ret->Criteria     = req1;
	ret->RateCriteria = req2;
}
#endif

#endif
