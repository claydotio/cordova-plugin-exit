package com.clay.exit;

import android.app.Activity;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaResourceApi;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

public class Exit extends CordovaPlugin {

  public Exit() {
  }

  /**
   * Executes the request and returns PluginResult.
   *
   * @param action      The action to execute.
   * @param args        JSONArray of arguments for the plugin.
   * @param callbackContext   The callback context used when calling back into JavaScript.
   * @return          True when the action was valid, false otherwise.
   */
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
  	/*
  	 * Don't run any of these if the current activity is finishing
  	 * in order to avoid android.view.WindowManager$BadTokenException
  	 * crashing the app. Just return true here since false should only
  	 * be returned in the event of an invalid action.
  	 */

  	if(this.cordova.getActivity().isFinishing()) return true;

    if (action.equals("exitWithoutAnimation")) {
      this.exitWithoutAnimation();
    }
    else {
      return false;
    }

    callbackContext.success();
    return true;
  }

  // LOCAL METHODS

  private void exitWithoutAnimation() {
    final Activity activity = this.cordova.getActivity();

    Runnable runnable = new Runnable() {
      public void run() {
        activity.finish();
        activity.overridePendingTransition(0, 0);
      }
    };
    this.cordova.getThreadPool().execute(runnable);
  }
}
