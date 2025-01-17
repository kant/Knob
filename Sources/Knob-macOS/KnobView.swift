// Copyright © 2021 Brad Howes. All rights reserved.

#if os(macOS)

import SwiftUI
import AppKit

/**
 Wrapper for a Knob control that allows it to reside in and take part in a SwiftUI view definition.
 */
@available(iOS 13, macOS 10.15, *)
public struct KnobView: NSViewRepresentable {

  /// The current value of the Knob
  @Binding private var value: Float
  /// Signal that the knob is being manipulated
  @Binding private var manipulating: Bool

  private var minimumValue: Float
  private var maximumValue: Float
  private var touchSensitivity: CGFloat = 1.0
  private var maxChangeRegionWidthPercentage: CGFloat = 0.1

  private var trackLineWidth: CGFloat = 6
  private var trackColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)

  private var progressLineWidth: CGFloat = 4
  private var progressColor: Color = Color(red: 1.0, green: 0.575, blue: 0.0)

  private var indicatorLineWidth: CGFloat = 4
  private var indicatorColor: Color = Color(red: 1.0, green: 0.575, blue: 0.0)
  private var indicatorLineLength: CGFloat = 0.3

  private var tickCount: Int = 0
  private var tickLineOffset: CGFloat = 0.1
  private var tickLineLength: CGFloat = 0.2
  private var tickLineWidth: CGFloat = 1.0
  private var tickColor: Color = .black

  public init(value: Binding<Float>, manipulating: Binding<Bool>, minimum: Float = 0.0, maximum: Float = 1.0) {
    self._value = value
    self._manipulating = manipulating
    self.minimumValue = minimum
    self.maximumValue = maximum
  }

  /**
   Create a new Knob control to be managed in SwiftUI.

   - parameter context: the context where the control will live
   - returns: the new Knob control
   */
  public func makeNSView(context: Context) -> Knob { makeView(context: context) }

  /**
   Update the Knob to show changes in the value binding.

   - parameter uiView: the Knob to update
   - parameter context: the context where the control lives
   */
  public func updateNSView(_ view: Knob, context: Context) { updateView(view, context: context) }

  func makeView(context: Context) -> Knob {
    let knob = Knob()
    context.coordinator.monitor(knob)
    updateView(knob, context: context)
    return knob
  }

  func updateView(_ view: Knob, context: Context) {
    view.value = value

    view.minimumValue = minimumValue
    view.maximumValue = maximumValue

    view.touchSensitivity = touchSensitivity
    view.maxChangeRegionWidthPercentage = maxChangeRegionWidthPercentage

    view.trackLineWidth = trackLineWidth
    view.progressLineWidth = progressLineWidth

    view.indicatorLineWidth = indicatorLineWidth
    view.indicatorLineLength = indicatorLineLength

    view.tickCount = tickCount
    view.tickLineOffset = tickLineOffset
    view.tickLineLength = tickLineLength
    view.tickLineWidth = tickLineWidth

    if #available(iOS 14, macOS 11, *) {
      view.trackColor = NSColor(trackColor)
      view.progressColor = NSColor(progressColor)
      view.indicatorColor = NSColor(indicatorColor)
      view.tickColor = NSColor(tickColor)
    }
  }

  /**
   Create a new coordinator that will monitor the Knob value changes.

   - returns: new Coordinator
   */
  public func makeCoordinator() -> KnobView.Coordinator { Coordinator(self) }

  /**
   Coordinator allows us to monitor valueChanged actions from a Knob and forward the values to the binding in the
   KnobView
   */
  public class Coordinator: NSObject {
    private var knobView: KnobView

    public init(_ knobView: KnobView) { self.knobView = knobView }

    func monitor(_ knob: Knob) {
      knob.target = self
      knob.action = #selector(valueChanged(_:))
    }

    @objc func valueChanged(_ sender: Knob) {
      knobView.value = sender.value
      knobView.manipulating = sender.manipulating
    }
  }
}

@available(iOS 13, macOS 10.15, *)
public extension KnobView {

  func touchSensitivity(_ value: CGFloat) -> KnobView {
    var view = self
    view.touchSensitivity = value
    return view
  }

  func maxChangeRegionWidthPercentage(_ value: CGFloat) -> KnobView {
    var view = self
    view.maxChangeRegionWidthPercentage = value
    return view
  }

  func trackStyle(width: CGFloat, color: Color) -> KnobView {
    var view = self
    view.trackLineWidth = width
    view.trackColor = color
    return view
  }

  func progressStyle(width: CGFloat, color: Color) -> KnobView {
    var view = self
    view.progressLineWidth = width
    view.progressColor = color
    return view
  }

  func indicatorStyle(length: CGFloat) -> KnobView {
    var view = self
    view.indicatorLineWidth = progressLineWidth
    view.indicatorColor = progressColor
    view.indicatorLineLength = length
    return view
  }

  func indicatorStyle(width: CGFloat, color: Color, length: CGFloat) -> KnobView {
    var view = self
    view.indicatorLineWidth = width
    view.indicatorColor = color
    view.indicatorLineLength = length
    return view
  }

  func tickStyle(count: Int, offset: CGFloat, length: CGFloat, width: CGFloat, color: Color) -> KnobView {
    var view = self
    view.tickCount = count
    view.tickLineOffset = offset
    view.tickLineLength = length
    view.tickLineWidth = width
    view.tickColor = color
    return view
  }
}

#endif
