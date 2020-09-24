#include "truckstop.h"

//#include <boost/program_options.hpp>
//#include <getopt.h>

#include <algorithm>
//#include <chrono>
#include <cstdlib>
#include <exception>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <memory>
#include <sstream>
#include <string>
#include <ctime>

const char config_fname[] = "truckstop-client.conf";

enum data_fields
{
	pickup_date,
	equipment_type,
	origin_city,
	origin_state,
	origin_country,
	origin_range,
	destination_city,
	destination_state,
	destination_country,
	destination_range,
	count,
};

/// debug only
#warning debug only!

#define STOP_IF_IN_USE() throw std::runtime_error("In use")

class string : public std::basic_string<char>
{
	typedef std::basic_string<char> base;
public:
	~string()
	{
		std::cout << "string::~string(), " << *this << std::endl;
	}
	operator base() { return *this; }
};
/// end of debug only

/// stuff

template <typename T>
std::string printable(T val)
{//STOP_IF_IN_USE();
	std::ostringstream buf;

	if( val )
		buf << *val;
	else
		buf << "<null>";

	return buf.str();
}

template <>
std::string printable(bool *val)
{//STOP_IF_IN_USE();
	std::ostringstream buf;

	if( val )
		buf << ( *val ? "true" : "false" );
	else
		buf << "<null>";

	return buf.str();
}

template <>
std::string printable(int val)
{//STOP_IF_IN_USE();
	std::ostringstream buf;
	buf << val;
	return buf.str();
}

template <>
std::string printable(LS::LoadType val)
{//STOP_IF_IN_USE();
	std::string msg;

	switch(val)
	{
	case LS::LoadType::Nothing:
		msg = "Nothing";
		break;
	case LS::LoadType::All:
		msg = "All";
		break;
	case LS::LoadType::Full:
		msg = "Full";
		break;
	case LS::LoadType::Partial:
		msg = "Partial";
		break;
	default:
		msg = "<unrecognized>";
	}

	return msg;
}

template <>
std::string printable(time_t *val)
{//STOP_IF_IN_USE();
	std::string msg(ctime(val));
	msg.erase(std::remove(msg.begin(), msg.end(), '\n'), msg.end());
	return msg;
}

template <>
std::string printable(LS::TrailerOptionType *val)
{//STOP_IF_IN_USE();
	std::string msg;

	if(val)
	{
		switch(*val)
		{
		case LS::TrailerOptionType::Tarps:
			msg.append("Tarps");
			break;
		case LS::TrailerOptionType::Hazardous:
			msg.append("Hazardous");
			break;
		case LS::TrailerOptionType::PalletExchange:
			msg.append("PalletExchange");
			break;
		case LS::TrailerOptionType::Team:
			msg.append("Team");
			break;
		case LS::TrailerOptionType::Expedited:
			msg.append("Expedited");
			break;
		default:
			msg.append("<unrecognized>");
		}

		return msg;
	}

	return "<null>";
}

template <>
std::string printable(LS::ArrayOfTrailerOptionType *val)
{//STOP_IF_IN_USE();
	std::ostringstream buf;

	if( val )
	{
		auto &v = val->TrailerOptionType;
		for(auto i = v.begin(); i != v.end(); ++i)
		{
			switch(*i)
			{
			case LS::TrailerOptionType::Tarps:
				buf << "Tarps";
				break;
			case LS::TrailerOptionType::Hazardous:
				buf << "Hazardous";
				break;
			case LS::TrailerOptionType::PalletExchange:
				buf << "PalletExchange";
				break;
			case LS::TrailerOptionType::Team:
				buf << "Team";
				break;
			case LS::TrailerOptionType::Expedited:
				buf << "Expedited";
				break;
			default:
				buf << "<unrecognized>";
			}
			buf << ',';
		}
	}
	else
	{
		buf << "<null>";
		return buf.str();
	}

	if( buf.str().size() )
	{
		std::string msg = buf.str();
		msg.pop_back();
		return msg;
	}

	return "<empty>";
}

std::ostream &operator<<(std::ostream &out, LS::LoadType type)
{STOP_IF_IN_USE();
	std::string msg;

	switch(type)
	{
	case LS::LoadType::Nothing:
		msg = "Nothing";
		break;
	case LS::LoadType::All:
		msg = "All";
		break;
	case LS::LoadType::Full:
		msg = "Full";
		break;
	case LS::LoadType::Partial:
		msg = "Partial";
		break;
	default:
		msg = "<unrecognized>";
	}

	return out << msg;
}

std::ostream &operator<<(std::ostream &out, LS::ArrayOfTrailerOptionType type)
{STOP_IF_IN_USE();
	std::string msg;

	auto &v = type.TrailerOptionType;
	for(auto i = v.begin(); i != v.end(); ++i)
	{
		switch(*i)
		{
		case LS::TrailerOptionType::Tarps:
			msg.append("Tarps");
			break;
		case LS::TrailerOptionType::Hazardous:
			msg.append("Hazardous");
			break;
		case LS::TrailerOptionType::PalletExchange:
			msg.append("PalletExchange");
			break;
		case LS::TrailerOptionType::Team:
			msg.append("Team");
			break;
		case LS::TrailerOptionType::Expedited:
			msg.append("Expedited");
			break;
		default:
			msg.append("<unrecognized>");
		}

		msg.push_back(',');
	}

	if(msg.size())
	{
		msg.pop_back();
	}
	else
	{
		msg.append("<empty>");
	}

	return out << msg;
}

std::ostream &operator<<(std::ostream &out, LS::EquipmentTypes type)
{//STOP_IF_IN_USE();
	std::stringstream msg;

	msg << "Id="              << printable(type.Id) << ':';
	msg << "CategoryId="      << printable(type.CategoryId) << ':';
	msg << "Category="        << printable(type.Category) << ':';
	msg << "Code="            << printable(type.Code) << ':';
	msg << "Description="     << printable(type.Description) << ':';
	msg << "FullLoad="        << printable(type.FullLoad) << ':';
	msg << "IsCategorizable=" << printable(type.IsCategorizable) << ':';
	msg << "IsCombo="         << printable(type.IsCombo) << ':';
	msg << "IsTruckPost="     << printable(type.IsTruckPost) << ':';
	msg << "MapToId="         << printable(type.MapToId) << ':';
	msg << "RequiredOption="  << printable(type.RequiredOption) << ':';
	msg << "WebserviceOnly="  << printable(type.WebserviceOnly);

	return out << msg.str();
}

std::ostream &operator<<(std::ostream &out, LS::LoadSearchResultsResponse res)
{//STOP_IF_IN_USE();
	auto &v = res.GetLoadSearchResultsResult->SearchResults->LoadSearchItem;

	out << "ID;Age;Bond;BondEnabled;BondTypeID;CompanyName;Days2Pay;"
		   "DestinationCity;DestinationCountry;DestinationDistance;"
		   "DestinationState;Equipment;EquipmentOptions;ExperienceFactor;"
		   "FuelCost;IsFriend;Length;LoadType;Miles;ModeShortDescription;"
		   "OriginCity;OriginCountry;OriginDistance;OriginState;Payment;"
		   "PickUpDate;PointOfContactPhone;PricePerGall;TruckCompanyId;Weight;"
		   "Width" << std::endl;

	for(auto i = v.begin(); i != v.end(); ++i)
	{
		out << printable((*i)->ID) << ';';
		out << printable((*i)->Age) << ';';
		out << printable((*i)->Bond) << ';';
		out << printable((*i)->BondEnabled) << ';';
		out << printable((*i)->BondTypeID) << ';';
		out << printable((*i)->CompanyName) << ';';
		out << printable((*i)->Days2Pay) << ';';
		out << printable((*i)->DestinationCity) << ';';
		out << printable((*i)->DestinationCountry) << ';';
		out << printable((*i)->DestinationDistance) << ';';
		out << printable((*i)->DestinationState) << ';';
		out << printable((*i)->Equipment) << ';';
		out << printable((*i)->EquipmentOptions) << ';';
		out << printable((*i)->ExperienceFactor) << ';';
		out << printable((*i)->FuelCost) << ';';
		out << printable((*i)->IsFriend) << ';';
		out << printable((*i)->Length) << ';';
		out << printable((*i)->LoadType) << ';';
		out << printable((*i)->Miles) << ';';
		out << printable((*i)->ModeShortDescription) << ';';
		out << printable((*i)->OriginCity) << ';';
		out << printable((*i)->OriginCountry) << ';';
		out << printable((*i)->OriginDistance) << ';';
		out << printable((*i)->OriginState) << ';';
		out << printable((*i)->Payment) << ';';
		out << printable((*i)->PickUpDate) << ';';
		out << printable((*i)->PointOfContactPhone) << ';';
		out << printable((*i)->PricePerGall) << ';';
		out << printable((*i)->TruckCompanyId) << ';';
		out << printable((*i)->Weight) << ';';
		out << printable((*i)->Width) << std::endl;
	}

	return out;
}

std::ostream &operator<<(std::ostream &out, LS::MultipleLoadDetailResultsResponse res)
{//STOP_IF_IN_USE();
	auto &v = res.GetMultipleLoadDetailResultsResult->DetailResults->MultipleLoadDetailResult;

	out << "ID;Age;Bond;BondTypeID;Credit;DOTNumber;DeletedId;"
		   "DeliveryDate;DeliveryTime;DestinationCity;DestinationCountry;"
		   "DestinationDistance;DestinationState;DestinationZip;Distance;"
		   "Entered;Equipment;EquipmentOptions;EquipmentTypes;ExperienceFactor;"
		   "FuelCost;HandleName;HasBonding;IsDeleted;IsFriend;Length;LoadType;"
		   "MCNumber;Mileage;OriginCity;OriginCountry;OriginDistance;"
		   "OriginState;OriginZip;PaymentAmount;PickupDate;PickupTime;"
		   "PointOfContact;PointOfContactPhone;PricePerGallon;Quantity;"
		   "SpecInfo;Stops;TMCNumber;TruckCompanyCity;TruckCompanyEmail;"
		   "TruckCompanyFax;TruckCompanyId;TruckCompanyName;TruckCompanyPhone;"
		   "TruckCompanyState;Weight;Width;" << std::endl;

	for(auto i = v.begin(); i != v.end(); ++i)
	{
		out << printable((*i)->ID) << ';';
		out << printable((*i)->Age) << ';';
		out << printable((*i)->Bond) << ';';
		out << printable((*i)->BondTypeID) << ';';
		out << printable((*i)->Credit) << ';';
		out << printable((*i)->DeletedId) << ';';
		out << printable((*i)->DeliveryDate) << ';';
		out << printable((*i)->DeliveryTime) << ';';
		out << printable((*i)->DestinationCity) << ';';
		out << printable((*i)->DestinationCountry) << ';';
		out << printable((*i)->DestinationDistance) << ';';
		out << printable((*i)->DestinationState) << ';';
		out << printable((*i)->DestinationZip) << ';';
		out << printable((*i)->Distance) << ';';
		out << printable((*i)->DOTNumber) << ';';
		out << printable((*i)->Entered) << ';';
		out << printable((*i)->Equipment) << ';';
		out << printable((*i)->EquipmentOptions) << ';';
		out << printable((*i)->EquipmentTypes) << ';';
		out << printable((*i)->ExperienceFactor) << ';';
		out << printable((*i)->FuelCost) << ';';
		out << printable((*i)->HandleName) << ';';
		out << printable((*i)->HasBonding) << ';';
		out << printable((*i)->IsDeleted) << ';';
		out << printable((*i)->IsFriend) << ';';
		out << printable((*i)->Length) << ';';
		out << printable((*i)->LoadType) << ';';
		out << printable((*i)->MCNumber) << ';';
		out << printable((*i)->Mileage) << ';';
		out << printable((*i)->OriginCity) << ';';
		out << printable((*i)->OriginCountry) << ';';
		out << printable((*i)->OriginDistance) << ';';
		out << printable((*i)->OriginState) << ';';
		out << printable((*i)->OriginZip) << ';';
		out << printable((*i)->PaymentAmount) << ';';
		out << printable((*i)->PickupDate) << ';';
		out << printable((*i)->PickupTime) << ';';
		out << printable((*i)->PointOfContact) << ';';
		out << printable((*i)->PointOfContactPhone) << ';';
		out << printable((*i)->PricePerGallon) << ';';
		out << printable((*i)->Quantity) << ';';
		out << printable((*i)->SpecInfo) << ';';
		out << printable((*i)->Stops) << ';';
		out << printable((*i)->TMCNumber) << ';';
		out << printable((*i)->TruckCompanyCity) << ';';
		out << printable((*i)->TruckCompanyEmail) << ';';
		out << printable((*i)->TruckCompanyFax) << ';';
		out << printable((*i)->TruckCompanyId) << ';';
		out << printable((*i)->TruckCompanyName) << ';';
		out << printable((*i)->TruckCompanyPhone) << ';';
		out << printable((*i)->TruckCompanyState) << ';';
		out << printable((*i)->Weight) << ';';
		out << printable((*i)->Width) << ';' << std::endl;
	}

	return out;
}

const unsigned inid = 487019;
const char user[]   = "anheuserws";
const char pass[]   = "Bu5ch1!";

std::string config = "/etc/truckstop/client.conf";

std::ostream &out = std::cout;

static inline void dummy(...)
{ ; }

int main(int argc, char *argv[], char *env[])
{
	dummy(argc, argv, env); /// be quiet here yet!

	setenv("TZ", "GMT", 1);
	tzset();

#if 1
	auto username = std::make_shared<std::string>(user);
	auto password = std::make_shared<std::string>(pass);
#else
	std::unique_ptr<string> username = std::make_unique<string>();
	username->append(user);
	std::unique_ptr<string> password = std::make_unique<string>();
	password->append(pass);
#endif

	std::ifstream conf(config_fname);

	if( ! conf.is_open() )
	{
		std::cerr << "Can't find file '" << config_fname << "' in current dir."
				  << std::endl;
		exit(EXIT_FAILURE);
	}

	for(; !conf.eof();)
	{
		char buff[256];
		conf.getline(buff, 255, '\n');
		std::stringstream b(buff);
		std::vector<std::string> data;
		for(; !b.eof();)
		{
			char buff[256];
			b.getline(buff, 255, ';');
			data.push_back(std::string(buff));
		}

		if( data.size() != data_fields::count )
			break;

		out << "SECTION: " << buff << std::endl;

		tm bdtime;
		memset(&bdtime, 1, sizeof(bdtime));
		strptime(data[data_fields::pickup_date].c_str(), "%Y-%m-%dT%H:%M:%S%z",
				&bdtime);

		time_t time = - bdtime.tm_gmtoff;
		time += mktime(&bdtime);

		{
			TruckStop ts(out, std::clog, std::cerr);

			std::shared_ptr<LS::LoadSearchRequest> req =
					std::make_shared<LS::LoadSearchRequest>();
			{{
					req->IntegrationId = inid;
		#if 1
					req->UserName      = new std::string(user);
					req->Password      = new std::string(pass);
		#else
					req->UserName = std::move(username.get());
					req->Password = std::move(password.get());
					string *u = username.get();
					string *p = password.get();

					req.reset();
		#endif
			}}

			req->Criteria = new LS::LoadSearchCriteria;
			{{
					auto crt = req->Criteria;

					/// Origin:
					/// {State}, {City and State}, {City, State, and Country}, or
					/// {latitude and longitude}.
					/// In the last case those values should be  multiplied by 100.
					crt->OriginCity         = &data[data_fields::origin_city];
					crt->OriginState        = &data[data_fields::origin_state];
					crt->OriginCountry      = &data[data_fields::origin_country];
					//crt->OriginLatitude     = new int(0*100);
					//crt->OriginLongitude    = new int(0*100);
					/// Range is optional and if included needs to be within 25 and 300:
					//crt->OriginRange        = 300;
					crt->OriginRange        = atoi(data[data_fields::origin_range].c_str());

					/// Destination:
					/// {State}, {City and State}, {City, State, and Country}, or
					/// {latitude and longitude}.
					/// In the last case manual lies - there are no fields available.
					crt->DestinationCity    = &data[data_fields::destination_city];
					crt->DestinationState   = &data[data_fields::destination_state];
					crt->DestinationCountry = &data[data_fields::destination_country];
					/// Range is optional and if included needs to be within 25 and 300:
					//crt->DestinationRange   = 300;
					crt->DestinationRange   = atoi(data[data_fields::destination_range].c_str());

					crt->EquipmentOptions   = new LS::ArrayOfTrailerOptionType;
					{{
#if 0
							auto &v = crt->EquipmentOptions->TrailerOptionType;
							v.push_back(LS::TrailerOptionType::Tarps);
							v.push_back(LS::TrailerOptionType::PalletExchange);
							v.push_back(LS::TrailerOptionType::Hazardous);
							v.push_back(LS::TrailerOptionType::Team);
							v.push_back(LS::TrailerOptionType::Expedited);
#endif
					}}

					//crt->EquipmentType = new std::string("V");
					//crt->EquipmentType = new std::string("ANY");
					//crt->EquipmentType = new std::string("V,F");
					crt->EquipmentType = &data[data_fields::equipment_type];

					//crt->HoursOld = new int(0);

					crt->LoadType = LS::LoadType::All;

					/// Paging functionality is available to specify the number of
					/// results per page and to select a page from the results.
					/// PageNumber specifies which page to select. Entering 0 will
					/// ignore the PageSize limit and return all results.
					/// PageSize specifies how many rows to return and must be a number
					/// not greater than 200.
					//crt->PageNumber = new int(1); crt->PageSize   = new int(50); /// working well
					//crt->PageNumber = new int(0); crt->PageSize   = new int(200); /// working well
					crt->PageNumber = new int(0);
					//crt->PageSize   = new int(200);

					crt->PickupDates = new LS::ArrayOfdateTime;
					{{
							crt->PickupDates->dateTime.push_back(time);
					}}

					crt->SortBy = new LS::SortColumn;
					{{
							*crt->SortBy = LS::SortColumn::Age;
					}}

					//crt->SortDescending = new bool(true);
			}}

#if 1
			std::shared_ptr<LS::LoadSearchResultsResponse> res(ts.GetLoadSearchResults(req.get()));
#else
			std::shared_ptr<LS::MultipleLoadDetailResultsResponse> res(ts.GetMultipleLoadDetailResults(req.get()));
#endif

			if( res )
			{
				out << *res;
			}
			else
			{
				out << std::string("<empty>");
				exit(SOAP_ERR);
			}

			out << std::endl;
		}
	}

	return 0;

#if 0
	{
		LS::LoadDetailRequest r;
		r.IntegrationId = req->IntegrationId;
		r.UserName      = req->UserName;
		r.Password      = req->Password;
		r.LoadId        = 1576477380;
		ts.GetLoadSearchDetailResults(&r);
	}

	{
		ts.GetMultipleLoadDetailResults(req.get());
	}

	{
		RM::RateSearchRequest *r = nullptr;
		ts.GetHistoricalRates(r);
	}

	{
		RM::NegotiationStrengthRequest *r = nullptr;
		ts.GetNegotiationStrength(r);
	}

	{
		RM::FuelSurchargeRequest *r = nullptr;
		ts.GetFuelSurcharge(r);
	}

	{
		RM::RateSearchRequest *r = nullptr;
		ts.GetRateIndex(r);
	}
#endif

#if 0
	BasicHttpBinding_USCOREILoadSearchProxy lsp;
	{
		lsp.soap->connect_timeout = 1;
		lsp.soap->connect_retry   = 9;
	}

	BasicHttpBinding_USCOREIRateMateProxy   rmp;
	{
		rmp.soap->accept_timeout = 1;
		rmp.soap->connect_retry  = 9;
	}

	rate__LaneSearchCriteria *lsc = new rate__LaneSearchCriteria;
	{
		lsc->EquipmentCategory = new objs__EquipmentCategory(objs__EquipmentCategory::Van);

		lsc->Origin      = new rate__Place;
		lsc->Destination = new rate__Place;

		lsc->Origin->Country      = new std::string("USA");
		lsc->Origin->State        = new std::string("TX");
		lsc->Origin->City         = new std::string("Dallas");

		lsc->Destination->Country = new std::string("USA");
		lsc->Destination->State   = new std::string("TX");
		lsc->Destination->City    = new std::string("Austin");
	}

	rate__RateSearchCriteria *rsc = new rate__RateSearchCriteria;
	{
		/// rsc->DesiredMargin = new double(20);
		rsc->Radius        = new rate__Radius(rate__Radius::Within100Miles);
	}

	rate__RateSearchRequest *rsr = new rate__RateSearchRequest;
	{
		rsr->IntegrationId = inid;
		rsr->UserName      = new std::string(user);
		rsr->Password      = new std::string(pass);

		rsr->Criteria      = lsc;
		rsr->RateCriteria  = rsc;
	}

	_rmsvc__GetHistoricalRates ghr;
	{
		ghr.request = rsr;
	}

	_rmsvc__GetHistoricalRatesResponse rsp;
	{
	}

	rmp.GetHistoricalRates(&ghr, rsp);
#endif
}
