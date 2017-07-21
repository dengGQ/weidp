package com.hhr.management.productManage.entity;
/*
* @Description: 产品
* @author dgq 
* @date 2017年7月20日
*/

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_product")
@Entity
public class Product implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@Id
  	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	private String productName;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}
	
	
}
