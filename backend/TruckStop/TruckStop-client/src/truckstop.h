#ifndef   TRUCKSTOP_CLIENT__TRUCKSTOP_H
#  define TRUCKSTOP_CLIENT__TRUCKSTOP_H

#include "soap.h"

#include <iostream>
#include <string>
#include <vector>

class TruckStop
{
private:
	TruckStop(const TruckStop &);

public:
	TruckStop(std::ostream &out, std::ostream &log, std::ostream &err);
	~TruckStop();

public:

	///*** LoadSearch service ***********************************************///

	LS::LoadSearchResultsResponse *
	GetLoadSearchResults(LS::LoadSearchRequest*);

	LS::LoadSearchDetailResultResponse *
	GetLoadSearchDetailResults(LS::LoadDetailRequest*);

	LS::MultipleLoadDetailResultsResponse *
	GetMultipleLoadDetailResults(LS::LoadSearchRequest*);

	///*** RateMate service *************************************************///

	RM::HistoricalRatesResponse *
	GetHistoricalRates(RM::RateSearchRequest*);

	RM::NegotiationStrengthResponse *
	GetNegotiationStrength(RM::NegotiationStrengthRequest*);

	RM::FuelSurchargeResponse *
	GetFuelSurcharge(RM::FuelSurchargeRequest*);

	RM::RateIndexResponse *
	GetRateIndex(RM::RateSearchRequest*);

private:
	TruckStop &operator=(const TruckStop &other);

private:
	class Private; Private *This;
};

#endif // TRUCKSTOP_CLIENT__TRUCKSTOP_H
