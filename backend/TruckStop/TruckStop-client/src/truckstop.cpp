#include "truckstop.h"
#include "soap.h"

#include "loadsearch.h"
#include "ratemate.h"

#include "soapBasicHttpBinding_USCOREILoadSearchProxy.h"
#include "soapBasicHttpBinding_USCOREIRateMateProxy.h"
#include "nsmap.h"

#include <cassert>
#include <memory>
#include <mutex>

/// class TruckStop::Private

class TruckStop::Private
{
	friend class TruckStop;

public:
	/// LoadSearch service
	LS::LoadSearchResultsResponse *GetLoadSearchResults(LS::LoadSearchRequest*);
	LS::LoadSearchDetailResultResponse *GetLoadSearchDetailResults(LS::LoadDetailRequest*);
	LS::MultipleLoadDetailResultsResponse *GetMultipleLoadDetailResults(LS::LoadSearchRequest*);

	/// RateMate service
	RM::HistoricalRatesResponse *GetHistoricalRates(RM::RateSearchRequest*);
	RM::NegotiationStrengthResponse *GetNegotiationStrength(RM::NegotiationStrengthRequest*);
	RM::FuelSurchargeResponse *GetFuelSurcharge(RM::FuelSurchargeRequest*);
	RM::RateIndexResponse *GetRateIndex(RM::RateSearchRequest*);

protected:
	Private(std::ostream &_out, std::ostream &_log, std::ostream &_err)
		: out(_out)
		, log(_log)
		, err(_err)
	{
		std::call_once(once, init, 0);
	}

private:

	void check(int) const;
#if 0
	void check(LS::LoadSearchResultsResponse *r) const
	{
		std::string msg = "SERVICE ERROR: ";

		auto &e = r->GetLoadSearchResultsResult->Errors->Error;
		if( e.size() )
		{
			err << msg << std::endl;
			for(auto i = e.begin(); i != e.end(); ++i)
			{
				err << "E: " << *(*i)->ErrorMessage << std::endl;

				auto &s = (*i)->Suggestions->string;
				for(auto j = s.begin(); j != s.end(); ++j)
				{
					err << "S: " << *j << std::endl;
				}
			}

			exit(SOAP_ERR);
		}

		return;
	}
#else
	void check(ReturnBase *r) const
	{
		std::string msg = "SERVICE ERROR: ";

		auto &e = r->Errors->Error;
		if( e.size() )
		{
			err << msg << std::endl;
			for(auto i = e.begin(); i != e.end(); ++i)
			{
				err << "E: " << *(*i)->ErrorMessage << std::endl;

				auto &s = (*i)->Suggestions->string;
				for(auto j = s.begin(); j != s.end(); ++j)
				{
					err << "S: " << *j << std::endl;
				}
			}

			exit(SOAP_ERR);
		}

		return;
	}
#endif

private:
	static std::once_flag once;
	static void init(int);

	template <typename Proxy, typename Result, typename Response>
	Response *proceed(Proxy *pro, Result *ret, int (Proxy::*fnc)(Result*, Response&))
	{
		Response *res = new Response;

		int _status = (pro->*fnc)(ret, *res);

		check(_status);
		check(base(res));

		return res;
	}

	static BasicHttpBinding_USCOREILoadSearchProxy *lsp;
	static BasicHttpBinding_USCOREIRateMateProxy   *rmp;

	std::ostream &out;
	std::ostream &log;
	std::ostream &err;
};

void
TruckStop::Private::init(int)
{
	lsp = new BasicHttpBinding_USCOREILoadSearchProxy;
	rmp = new BasicHttpBinding_USCOREIRateMateProxy;

	lsp->soap->connect_timeout = rmp->soap->connect_timeout = 1;
	lsp->soap->connect_retry   = rmp->soap->connect_retry   = 9;

	soap_set_mode(lsp->soap, SOAP_XML_INDENT);
	soap_set_mode(rmp->soap, SOAP_XML_INDENT);
}

BasicHttpBinding_USCOREILoadSearchProxy *TruckStop::Private::lsp;
BasicHttpBinding_USCOREIRateMateProxy   *TruckStop::Private::rmp;

std::once_flag TruckStop::Private::once;

LS::LoadSearchResultsResponse *
TruckStop::Private::GetLoadSearchResults(LS::LoadSearchRequest *req)
{
#if 1
	typedef  BasicHttpBinding_USCOREILoadSearchProxy  Proxy;
	typedef  LS::LoadSearchResults                    Result;
	typedef  LS::LoadSearchResultsResponse            Response;

///	std::shared_ptr<Result> res(new Result);
	std::shared_ptr<Result> res = std::make_shared<Result>();
#if 0
	{{
			res->searchRequest = req;
	}}
#else
	{{
			set_result(res.get(), req);
	}}
#endif

	int (Proxy::*fnc)(Result*, Response&) = &Proxy::GetLoadSearchResults;

	Response *_return = proceed(lsp, res.get(), fnc);

#else
	LS::LoadSearchResults *_result = new LS::LoadSearchResults;
	{{
			_result->searchRequest = req;
	}}

	LS::LoadSearchResultsResponse *_return = new LS::LoadSearchResultsResponse;

	int _status = lsp->GetLoadSearchResults(_result, *_return);

	check(_status);
	check(_return->GetLoadSearchResultsResult);
#endif

	return _return;
}

LS::LoadSearchDetailResultResponse *
TruckStop::Private::GetLoadSearchDetailResults(LS::LoadDetailRequest *req)
{
#if 1
	typedef  BasicHttpBinding_USCOREILoadSearchProxy  Proxy;
	typedef  LS::LoadSearchDetailResult               Result;
	typedef  LS::LoadSearchDetailResultResponse       Response;

	Result res; { res.detailRequest = req; }

	int (Proxy::*fnc)(Result*, Response&) = &Proxy::GetLoadSearchDetailResult;

	Response *_return = proceed(lsp, &res, fnc);
#else
	LS::LoadSearchDetailResult *_result = new LS::LoadSearchDetailResult;
	{{
			_result->detailRequest = req;
	}}

	LS::LoadSearchDetailResultResponse *_return =
			new LS::LoadSearchDetailResultResponse;

	int _status = lsp->GetLoadSearchDetailResult(_result, *_return);

	check(_status);
	check(_return->GetLoadSearchDetailResultResult);
#endif
	return _return;
}

LS::MultipleLoadDetailResultsResponse *
TruckStop::Private::GetMultipleLoadDetailResults(LS::LoadSearchRequest *req)
{
#if 1
	typedef  BasicHttpBinding_USCOREILoadSearchProxy  Proxy;
	typedef  LS::MultipleLoadDetailResults            Result;
	typedef  LS::MultipleLoadDetailResultsResponse    Response;

	Result res;
	{{
			res.searchRequest = req;
	}}

	int (Proxy::*fnc)(Result*, Response&) = &Proxy::GetMultipleLoadDetailResults;

	Response *_return = proceed(lsp, &res, fnc);
#else
	LS::MultipleLoadDetailResults *_result = new LS::MultipleLoadDetailResults;
	{{
			_result->searchRequest = req;
	}}

	LS::MultipleLoadDetailResultsResponse *_return =
			new LS::MultipleLoadDetailResultsResponse;

	int _status = lsp->GetMultipleLoadDetailResults(_result, *_return);

	check(_status);
	check(_return->GetMultipleLoadDetailResultsResult);
#endif
	return _return;
}

RM::HistoricalRatesResponse *
TruckStop::Private::GetHistoricalRates(RM::RateSearchRequest *req)
{
	typedef  BasicHttpBinding_USCOREIRateMateProxy    Proxy;
	typedef  RM::HistoricalRates                      Result;
	typedef  RM::HistoricalRatesResponse              Response;

	Result res; { res.request = req; }

	int (Proxy::*fnc)(Result*, Response&) = &Proxy::GetHistoricalRates;

	Response *_return = proceed(rmp, &res, fnc);

	return _return;
}

RM::NegotiationStrengthResponse *
TruckStop::Private::GetNegotiationStrength(RM::NegotiationStrengthRequest *req)
{
	typedef  BasicHttpBinding_USCOREIRateMateProxy    Proxy;
	typedef  RM::NegotiationStrength                  Result;
	typedef  RM::NegotiationStrengthResponse          Response;

	Result res; { res.request = req; }

	int (Proxy::*fnc)(Result*, Response&) = &Proxy::GetNegotiationStrength;

	Response *_return = proceed(rmp, &res, fnc);

	return _return;
}

RM::FuelSurchargeResponse *
TruckStop::Private::GetFuelSurcharge(RM::FuelSurchargeRequest *req)
{
	typedef  BasicHttpBinding_USCOREIRateMateProxy    Proxy;
	typedef  RM::FuelSurcharge                        Result;
	typedef  RM::FuelSurchargeResponse                Response;

	Result res; { res.request = req; }

	int (Proxy::*fnc)(Result*, Response&) = &Proxy::GetFuelSurcharge;

	Response *_return = proceed(rmp, &res, fnc);

	return _return;
}

RM::RateIndexResponse *
TruckStop::Private::GetRateIndex(RM::RateSearchRequest *req)
{
	typedef  BasicHttpBinding_USCOREIRateMateProxy    Proxy;
	typedef  RM::RateIndex                            Result;
	typedef  RM::RateIndexResponse                    Response;

	Result res; { res.request = req; }

	int (Proxy::*fnc)(Result*, Response&) = &Proxy::GetRateIndex;

	Response *_return = proceed(rmp, &res, fnc);

	return _return;
}

inline void
TruckStop::Private::check(int ret) const
{
	std::string msg = "NETWORK ERROR: ";

	if      ( ret == SOAP_OK )
	{
		return;
	}
	else if ( soap_xml_error_check(ret) )
	{
		msg.append("XML, code ");
	}
	else if ( soap_soap_error_check(ret) )
	{
		msg.append("SOAP, code ");
	}
	else if ( soap_http_error_check(ret) )
	{
		msg.append("HTTP, code ");
	}
	else if ( soap_dime_error_check(ret) )
	{
		msg.append("DIME, code ");
	}
	else if ( soap_mime_error_check(ret) )
	{
		msg.append("MIME, code ");
	}
	else if ( soap_tcp_error_check(ret) )
	{
		msg.append("TCP, code ");
	}
	else if ( soap_udp_error_check(ret) )
	{
		msg.append("UDP, code ");
	}
	else if ( soap_ssl_error_check(ret) )
	{
		msg.append("SSL, code ");
	}
	else if ( soap_zlib_error_check(ret) )
	{
		msg.append("ZLIB, code ");
	}

	err << msg << ret << std::endl;

	exit(ret);
}

/// class TruckStop

TruckStop::TruckStop(std::ostream &out, std::ostream &log, std::ostream &err)
{
	This = new TruckStop::Private(out, log, err);
}

TruckStop::~TruckStop()
{
	if( This )
	{
		delete This;
		This = nullptr;
	}
}

TruckStop &
TruckStop::operator=(const TruckStop &)
{
	This = nullptr;
	return *this;
}

LS::LoadSearchResultsResponse *
TruckStop::GetLoadSearchResults(LS::LoadSearchRequest *req)
{
	return This->GetLoadSearchResults(req);
}

LS::LoadSearchDetailResultResponse *
TruckStop::GetLoadSearchDetailResults(LS::LoadDetailRequest *req)
{
	return This->GetLoadSearchDetailResults(req);
}

LS::MultipleLoadDetailResultsResponse *
TruckStop::GetMultipleLoadDetailResults(LS::LoadSearchRequest *req)
{
	return This->GetMultipleLoadDetailResults(req);
}

RM::HistoricalRatesResponse *
TruckStop::GetHistoricalRates(RM::RateSearchRequest *req)
{
	return This->GetHistoricalRates(req);
}

RM::NegotiationStrengthResponse *
TruckStop::GetNegotiationStrength(RM::NegotiationStrengthRequest *req)
{
	return This->GetNegotiationStrength(req);
}

RM::FuelSurchargeResponse *
TruckStop::GetFuelSurcharge(RM::FuelSurchargeRequest *req)
{
	return This->GetFuelSurcharge(req);
}

RM::RateIndexResponse *
TruckStop::GetRateIndex(RM::RateSearchRequest *req)
{
	return This->GetRateIndex(req);
}
