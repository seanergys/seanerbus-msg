# SPDX-FileCopyrightText: 2026 SEANERGYS Partners <https://seanergys.eu>
#
# SPDX-License-Identifier: MIT

@0xec449ac8f0e6b560;

enum MessageTypes
{
    timeValueV1 @0;
    resolveReqV1 @1;
    resolveResV1 @2;
    helloWorldReqV1 @3;
    helloWorldResV1 @4;

    vectorReqV1 @5;
    vectorResV1 @6;

    reverseResolveReqV1 @7;
    reverseResolveResV1 @8;
    fluxLifecycleEventV1 @9;

    registerResolveReqV1 @10;
    registerResolveResV1 @11;

    unregisterResolveReqV1 @12;
    unregisterResolveResV1 @13;

    historyReqV1 @14;
    historyResV1 @15;

    fluxClassifyJobReqV1 @16;
    fluxClassifyJobResV1 @17;

    fluxLifecycleHeartbeatV1 @18;
}

struct TimeValueV1
{
    const type :MessageTypes = timeValueV1;
    time @0 :UInt64;
    value @1 :Float64;
}

struct KV
{
    key @0 :Text;
    value @1 :Text;
}

struct ResolveReqV1
{
    const type :MessageTypes = resolveReqV1;
    attributes @0 :List(KV);
}

struct Address
{
    lower @0 :UInt64;
    upper @1 :UInt64;
}

struct ResolveResV1
{
    const type:MessageTypes = resolveResV1;
    matchingInterfaces @0 :List(Address);
}

struct ReverseResolveReqV1
{
    const type :MessageTypes = reverseResolveReqV1;
    address @0 :Address;
}

struct ReverseResolveResV1
{
    const type :MessageTypes = reverseResolveResV1;
    name @0 :List(KV);
}

struct HelloWorldReqV1
{
    const type :MessageTypes = helloWorldReqV1;
    msg @0 :Text;
}

struct HelloWorldResV1
{
    const type :MessageTypes = helloWorldResV1;
    msg @0 :Text;
}


struct VectorReqV1
{
    const type :MessageTypes = vectorReqV1;
    values @0 :List(Float64);
}

struct VectorResV1
{
    const type :MessageTypes = vectorResV1;
    results @0 :List(Float64);
}

struct FluxLifecycleEventV1
{
    const type :MessageTypes = fluxLifecycleEventV1;
    data @0 :Text;
}

# Request for registering a address name mapping.
#
# The naming service responds with a ErrorResV1.
struct RegisterResolveReqV1
{
    const type :MessageTypes = registerResolveReqV1;
    name @0 :List(KV);
    address @1 :Address;
}

# Request for unregistering a address -> name mapping.
#
# The naming service responds with a ErrorResV1.
struct UnregisterResolveReqV1
{
    const type :MessageTypes = unregisterResolveReqV1;
    address @0 :Address;
}

struct Aggregate

{
    minimum @0: Float64;
    maximum @1: Float64;
    sum @2: Float64;
    count @3: UInt64;
    integral @4: Float64;
    activeTime @5: UInt64;
}

struct History
{
    timeDelta @0: List(Int64);
    rawOrAgg :union
    {
        value @1: List(Float64);
        aggregate @2: List(Aggregate);
    }
}

enum HistoryType 
{
    aggregate @0;
    flexTimeline @1;
}

# Request for historic time-series data.
# Is answered with:
# - HistoryResV1, if the request succeeded.
# - ErrorResV1, if the request failed.
struct HistoryReqV1
{
    const type :MessageTypes = historyReqV1;
    address @0: Address;
    startTime @1: Int64;
    endTime @2: Int64;
    intervalMax @3: Int64;
    historyType @4: HistoryType;
}


struct HistoryResV1
{
    const type :MessageTypes = historyResV1;
    hist @0 :History;
}

struct FluxClassifyJobReqV1
{
    const type :MessageTypes = fluxClassifyJobReqV1;
    jobspec @0: Text;
}

struct FluxClassifyJobResV1
{
    const type :MessageTypes = fluxClassifyJobResV1;
    result @0: Text;
}

enum ErrorCodeV1
{
    # No Error occurred.
    ok @0;
    # The requestee has sent a request which is not understood.
    wrongSchema @1;
}

struct ErrorResV1
{
     # For well known project-wide errors, error_code is one of ErrorCodeV1.
     # For use-case specific errors, this is a number >= 1ULL << 63
     errorCode @0 :UInt64;

     # If error_code != ErrorCodeV1::ok, then this may contain a human-readable description
     # of the error.
     what @1 :Text;
}
