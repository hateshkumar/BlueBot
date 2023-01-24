class BlueBotBaseState {
  final bool initializing;
  final bool primaryBusy;
  final bool secondaryBusy;
  final bool tertiaryBusy;
  final bool idle;
  final bool error;
  final bool empty;
  final dynamic data;

  BlueBotBaseState({
    bool initializing = false,
    bool busy = false,
    bool idle = false,
    bool error = false,
    bool empty = false,
    bool secondaryBusy = false,
    bool tertiaryBusy = false,
    dynamic data = dynamic,
  })  : this.initializing = initializing,
        this.primaryBusy = busy,
        this.idle = idle,
        this.error = error,
        this.empty = empty,
        this.secondaryBusy = secondaryBusy,
        this.tertiaryBusy = tertiaryBusy,
        this.data = data;

  BlueBotBaseState.initializing() : this(initializing: true);

  BlueBotBaseState.primaryBusy() : this(busy: true);

  BlueBotBaseState.idle() : this(idle: true);

  BlueBotBaseState.error() : this(error: true);

  BlueBotBaseState.empty() : this(empty: true);

  BlueBotBaseState.secondaryBusy() : this(secondaryBusy: true);

  BlueBotBaseState.tertiaryBusy() : this(tertiaryBusy: true);

  BlueBotBaseState.response(data) : this(data: data);
}
