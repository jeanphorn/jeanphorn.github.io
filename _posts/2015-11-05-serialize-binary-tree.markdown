---
layout:     post
title:      "序列化和反序列化二叉树"
subtitle:   " \"Serialize and deserialize binary tree\""
date:       2015-11-05 20:50:00
author:     "jeanphorn"
header-img: "img/in-post/post-serialize-bintree.png"
tags:
    - 二叉树 
	- 序列化 
	- 反序列化
---

<p id = "build"></p>

## 1. 描述
　　设计一个算法，实现二叉树的序列化与反序列化。如何实现没有限制，只要保证一颗二叉树可以序列化为一个string串，然后这个string串可以反序列化为原来的二叉树即可。详细描述如下：
　　![problem](http://img.blog.csdn.net/20151030105003302?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## 2. 方法与思路
　　采用先序遍历的思路，为了保证重构二叉树时，节点能够插入到数中的正确位置，空节点用“#”保存。为了保证从字符串中读取节点值方便，节点的值在字符串中用空格分开。重构时依旧安装先序的思想递归实现即可。
　　
　　序列化serialize：
　　

 1. if (root = null) : str += "# "
 2. 递归
	 str += root->data+ " "
	 serialize(root->left, str)
	 serialize(root->right, str)

　　反序列化：

 1 .读字符串中一个节点的值
 2 . $if $ not Digit
	    　　$return$
3 . 是数字
	root = new TreeNode(val);
   递归重构左右子树。

代码：

```
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */

class Codec {
public: 
    void serialize(TreeNode* root, string &str) {
        if(!root) str += "# ";
        else {
            ostringstream oss;
            oss << root->val;
            str += oss.str() + " ";
            serialize(root->left, str);
            serialize(root->right,str);
        }   
    }   
    void deserialize(TreeNode *&root, string &str) {
        int val;
        //if(str.length()==0) return;
        string tmp = str.substr(0,str.find(" ")); 
        str = str.substr(str.find(" ")+1);
        if(atoi(tmp.c_str()) || tmp.compare("0") == 0) {
            val = atoi(tmp.c_str());
            root = new TreeNode(val); 
            deserialize(root->left, str);
            deserialize(root->right, str);
        }   
        else
        {   
            root = NULL;
            return ;
        }   
    }   
    // Encodes a tree to a single string.
    string serialize(TreeNode* root) {
        string s="";
        serialize(root, s); 
        return s;
    }   

    // Decodes your encoded data to tree.
    TreeNode* deserialize(string data) {
        TreeNode *root = NULL;
        deserialize(root, data);
        return root;
    }   
};

```

