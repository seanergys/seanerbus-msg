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

    errorResV1 @19;

    getReqV1 @20;
    getResV1 @21;
    setReqV1 @22;
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

# Request to resolve the name 'name' (expressed as a list
# of key-value pairs to one or more entities.
struct ResolveReqV1
{
    const type :MessageTypes = resolveReqV1;
    name @0 :List(KV);
}

# An entity is a "thing" on the dataplane which you can perform actions to
# For example, the frequency of a core of some node is an entity.
# On this entity operations like Get and Set might be performed.
#
# Entities are identified by a UUID, encoded here into its upper and lower
# 64-bit
struct Entity
{
    lower @0 :UInt64;
    upper @1 :UInt64;
}

struct ResolveResV1
{
    const type:MessageTypes = resolveResV1;
    entities @0 :List(Entity);
    resolvedTerms @1 :List(List(KV));
}

struct ReverseResolveReqV1
{
    const type :MessageTypes = reverseResolveReqV1;
    entity @0 :Entity;
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

# Request for registering an entity -> name mapping.
#
# The naming service responds with a ErrorResV1.
struct RegisterResolveReqV1
{
    const type :MessageTypes = registerResolveReqV1;
    name @0 :List(KV);
    entity @1 :Entity;
}

# Request for unregistering an entity -> name mapping.
#
# The naming service responds with a ErrorResV1.
struct UnregisterResolveReqV1
{
    const type :MessageTypes = unregisterResolveReqV1;
    entity @0 :Entity;
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
    entity  @0: Entity;
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
    const type :MessageTypes = errorResV1;
     # For well known project-wide errors, error_code is one of ErrorCodeV1.
     # For use-case specific errors, this is a number >= 1ULL << 63
     errorCode @0 :UInt64;

     # If error_code != ErrorCodeV1::ok, then this may contain a human-readable description
     # of the error.
     what @1 :Text;
}

# Request for getting some value
#
# Answers with: 
#   - ErrorResV1 if something did go wrong
#   - GetResV1 if the operation succeeded
struct GetReqV1
{
    const type :MessageTypes = getReqV1;
}

struct GetResV1
{
    const type :MessageTypes = getResV1;
    value @0: UInt64;
    # If this timestamp is 0, then the time of the reading is not known by the reader
    time @1: UInt64;
}

# Request for setting some value
# 
# Answers with:
#    - ErrorResV1 with errorCode == ErrorCodeV1::Ok, if everything went okay
#    - ErrorResV1 with errorCode != ErrorCodeV1::Ok, if an error occured
struct SetReqV1
{
    const type :MessageTypes = setReqV1;
    value @0: UInt64;
}
