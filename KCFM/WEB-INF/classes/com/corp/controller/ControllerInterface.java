package com.corp.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

public interface ControllerInterface {

	public String getStringResult(HttpServletRequest request, HttpServletResponse response,HashMap paramHash) throws Exception;
}
