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
    attributes @0 :List(KV);
}

struct Address
{
    lower @0 :UInt64;
    upper @1 :UInt64;
}

struct ResolveResV1
{
    matchingInterfaces @0 :List(Address);
}

struct ReverseResolveReqV1
{
    address @0 :Address;
}

struct ReverseResolveResV1
{
    name @0 :List(KV);
}

struct HelloWorldReqV1
{
    msg @0 :Text;
}

struct HelloWorldResV1
{
    msg @0 :Text;
}


struct VectorReqV1
{
    values @0 :List(Float64);
}

struct VectorResV1
{
    results @0 :List(Float64);
}

struct FluxLifecycleEventV1
{
    data @0 :Text;
}

struct RegisterResolveReqV1
{
    name @0 :List(KV);
    address @1 :Address;
}

struct RegisterResolveResV1
{
    success @0: Bool;
    errMsg @1: Text;
}

struct UnregisterResolveReqV1
{
    address @0 :Address;
}

struct UnregisterResolveResV1
{
    success @0: Bool;
    errMsg @1: Text;
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

struct HistoryReqV1
{
    address @0: Address;
    startTime @1: Int64;
    endTime @2: Int64;
    intervalMax @3: Int64;
    type @4: HistoryType;
}

struct HistoryResV1
{
    okOrErr :union
    {
        ok @0 :History;
        err @1 :Text;
    }
}

struct FluxClassifyJobReqV1
{
    jobspec @0: Text;
}

struct FluxClassifyJobResV1
{
    result @0: Text;
}
