public import data.event;
import std.array;
import std.algorithm : filter;

alias void delegate() Handler;
alias Handler[] HandlerList;
alias Event[] EventList;

private HandlerList[Event] eventMap;
private EventList eventQ;

const(EventList) eventQueue() { return eventQ; }
void emptyEventQueue() { eventQ = []; }

void register(Event e, Handler h)
{
    if(e !in eventMap) eventMap[e] = [];
    eventMap[e] ~= h;
}

void unregister(Event e, Handler h)
{
    if(e !in eventMap) return;
    eventMap[e] = array(eventMap[e].filter!(a => a == h)());
}

void fire(Event e)
{
    eventQ ~= e;
}

void fireInstant(Event e)
{
    if(e !in eventMap) return;
    foreach(Handler h; eventMap[e])
    {
        h();
    }
}
