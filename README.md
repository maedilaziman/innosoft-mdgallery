# About
innosoft-mdgallery aims to help produce an easily usable implementation of taking image from gallery and camera.<br/>
<br/>
<br/>
<img src="https://raw.githubusercontent.com/maedilaziman/innosoft-mdgallery/master/Screenshots/IMG_0216.png" width="300" />
<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span><img src="https://raw.githubusercontent.com/maedilaziman/innosoft-mdgallery/master/Screenshots/IMG_0217.png" width="300" />
</br>
<br/>
<h2>Requirements</h2>
<ul>
<li>iOS 11.6</li>
<li>XCode 13.6</li>
<li>Swift 4.0+</li>
</ul>
<h2>Installation</h2>
<h4>CocoaPods</h4>
<pre>
<strong><span class="pl-en">pod 'MDSoftGallery', '~> 1.0'</span></strong>
or if above not run properly please use this
<p><strong><span class="pl-en">pod 'MDSoftGallery', :git => 'https://github.com/maedilaziman/innosoft-mdgallery.git'</span></strong></p>
</pre>
<h4>Manual</h4>
Just the files from the <b>MDSoftGallery</b> subfolder to your project.
<br/>
<h2>Setup</h2>
It needs a extension:
<pre><p class="p1"><span class="s1"><strong>extension</strong></span> ViewController<span class="s2">: </span>CameraPhoto_Communicate<span class="s2"> {</span></p>
<p class="p2"><span class="Apple-converted-space">&nbsp; &nbsp; </span><span class="s1"><strong>func</strong></span> <span class="s3">getAllPhotos</span>(images: [<span class="s4">UIImage</span>]) {</p>
<p class="p3"><span class="s2"><span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp; </span></span><span class="s5">print</span><span class="s2">(</span>"get_all_photos == <span class="s2">\(images)</span>"<span class="s2">)</span></p>
<p class="p2"><span class="Apple-converted-space">&nbsp; &nbsp; </span>}</p>
<p class="p2">}</p></pre>
<h2>Usage</h2>
Declare CalendarCst() and call showMDSoftCalendar function like this example.
<br/>
<br/>
<pre><p class="p1"><span class="s1"><strong>import</strong></span> UIKit
<span class="s1"><strong>import</strong></span> MDSoftCalendar</p>
<p class="p3"><span class="s1"><strong>extension</strong></span> ViewController<span class="s2">: </span>CalendarCst_Communicate<span class="s2">{</span>
<span class="Apple-converted-space">&nbsp; &nbsp; </span><span class="s1"><strong>func</strong></span> <span class="s3">getCalendarValue</span>(value: [<span class="s4">String</span>]) {
<span class="s2"><span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp; </span></span><span class="s5">print</span><span class="s2">(</span>"Value Calendar = <span class="s2">\(value)</span>"<span class="s2">)</span>
<span class="Apple-converted-space">&nbsp; &nbsp; </span>}
}</p>
<p class="p5"><span class="s1"><strong>class</strong></span> <span class="s6">ViewController</span><span class="s2">: </span>UIViewController<span class="s2"> {</span></p>
<p class="p6"><span class="s2"><span class="Apple-converted-space">&nbsp; &nbsp; </span></span><strong>override</strong> <strong>func</strong> <span class="s3">viewDidLoad</span><span class="s2">() {</span>
<span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp; </span><span class="s1"><strong>super</strong></span>.<span class="s5">viewDidLoad</span>()
<span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp; </span></span>// Do any additional setup after loading the view.
<span class="Apple-converted-space">&nbsp; &nbsp; </span>}</p>
<p class="p1"><span class="Apple-converted-space">&nbsp; &nbsp; </span><span class="s1"><strong>@IBAction</strong></span> <span class="s1"><strong>func</strong></span> <span class="s3">actShowCalendar</span>(<span class="s1"><strong>_</strong></span> sender: <span class="s1"><strong>Any</strong></span>) {
<span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp; </span><span class="s1"><strong>let</strong></span> calendarCst = <span class="s7">CalendarCst</span>()
<span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp; </span>calendarCst.<span class="s8">showMDSoftCalendar</span>(comm: <span class="s1"><strong>self</strong></span>, background: <span class="s4">UIColor</span>.<span class="s5">black</span>, backgroundWithSemiTransparent: <span class="s1"><strong>true</strong></span>, closeCalendarWhenItemChoosed: <span class="s1"><strong>true</strong></span>)
<span class="Apple-converted-space">&nbsp; &nbsp; </span>}</p>
<p class="p1">}</p></pre>
<br/>
That's it!
<br/>
<h2>License</h2>
<pre><code>Copyright 2020 Maedi Laziman
<br/>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
<br/>
   http://www.apache.org/licenses/LICENSE-2.0
<br/>
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.</code></pre>
