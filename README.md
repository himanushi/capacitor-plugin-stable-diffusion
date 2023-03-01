# capacitor-plugin-stable-diffusion

only iOS and iPadOS

## Install

```bash
npm install capacitor-plugin-stable-diffusion
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`download(...)`](#download)
* [`unzip(...)`](#unzip)
* [`generateTextToImage(...)`](#generatetexttoimage)
* [`addListener('downloadProgress', ...)`](#addlistenerdownloadprogress)
* [`addListener('downloadDidComplete', ...)`](#addlistenerdownloaddidcomplete)
* [`addListener('unzipDidComplete', ...)`](#addlistenerunzipdidcomplete)
* [`addListener('generateProgress', ...)`](#addlistenergenerateprogress)
* [`addListener('generateDidComplete', ...)`](#addlistenergeneratedidcomplete)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### download(...)

```typescript
download(options: DownloadOptions) => Promise<void>
```

| Param         | Type                                                        |
| ------------- | ----------------------------------------------------------- |
| **`options`** | <code><a href="#downloadoptions">DownloadOptions</a></code> |

--------------------


### unzip(...)

```typescript
unzip(options: UnzipOptions) => Promise<void>
```

| Param         | Type                                                  |
| ------------- | ----------------------------------------------------- |
| **`options`** | <code><a href="#unzipoptions">UnzipOptions</a></code> |

--------------------


### generateTextToImage(...)

```typescript
generateTextToImage(options: GenerateTextToImageOptions) => Promise<void>
```

| Param         | Type                                                                              |
| ------------- | --------------------------------------------------------------------------------- |
| **`options`** | <code><a href="#generatetexttoimageoptions">GenerateTextToImageOptions</a></code> |

--------------------


### addListener('downloadProgress', ...)

```typescript
addListener(eventName: 'downloadProgress', listenerFunc: DownloadProgressListener) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                          |
| ------------------ | ----------------------------------------------------------------------------- |
| **`eventName`**    | <code>'downloadProgress'</code>                                               |
| **`listenerFunc`** | <code><a href="#downloadprogresslistener">DownloadProgressListener</a></code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### addListener('downloadDidComplete', ...)

```typescript
addListener(eventName: 'downloadDidComplete', listenerFunc: DownloadDidCompleteListener) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                                |
| ------------------ | ----------------------------------------------------------------------------------- |
| **`eventName`**    | <code>'downloadDidComplete'</code>                                                  |
| **`listenerFunc`** | <code><a href="#downloaddidcompletelistener">DownloadDidCompleteListener</a></code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### addListener('unzipDidComplete', ...)

```typescript
addListener(eventName: 'unzipDidComplete', listenerFunc: UnzipDidCompleteListener) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                          |
| ------------------ | ----------------------------------------------------------------------------- |
| **`eventName`**    | <code>'unzipDidComplete'</code>                                               |
| **`listenerFunc`** | <code><a href="#unzipdidcompletelistener">UnzipDidCompleteListener</a></code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### addListener('generateProgress', ...)

```typescript
addListener(eventName: 'generateProgress', listenerFunc: GenerateProgressListener) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                          |
| ------------------ | ----------------------------------------------------------------------------- |
| **`eventName`**    | <code>'generateProgress'</code>                                               |
| **`listenerFunc`** | <code><a href="#generateprogresslistener">GenerateProgressListener</a></code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### addListener('generateDidComplete', ...)

```typescript
addListener(eventName: 'generateDidComplete', listenerFunc: GenerateDidCompleteListener) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                                |
| ------------------ | ----------------------------------------------------------------------------------- |
| **`eventName`**    | <code>'generateDidComplete'</code>                                                  |
| **`listenerFunc`** | <code><a href="#generatedidcompletelistener">GenerateDidCompleteListener</a></code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### Interfaces


#### DownloadOptions

| Prop                | Type                |
| ------------------- | ------------------- |
| **`url`**           | <code>string</code> |
| **`modelsDirName`** | <code>string</code> |


#### UnzipOptions

| Prop                | Type                |
| ------------------- | ------------------- |
| **`url`**           | <code>string</code> |
| **`modelsDirName`** | <code>string</code> |


#### GenerateTextToImageOptions

| Prop            | Type                |
| --------------- | ------------------- |
| **`modelPath`** | <code>string</code> |
| **`savePath`**  | <code>string</code> |
| **`prompt`**    | <code>string</code> |
| **`seed`**      | <code>number</code> |


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


### Type Aliases


#### DownloadProgressListener

<code>(data: { progress: number; }): void</code>


#### DownloadDidCompleteListener

<code>(data: <a href="#downloaddidcompleteresult">DownloadDidCompleteResult</a>): void</code>


#### DownloadDidCompleteResult

<code>{ state: 'completed' | 'fail'; error?: string; }</code>


#### UnzipDidCompleteListener

<code>(data: <a href="#unzipdidcompleteresult">UnzipDidCompleteResult</a>): void</code>


#### UnzipDidCompleteResult

<code>{ state: 'completed'; }</code>


#### GenerateProgressListener

<code>(data: { progress: number; }): void</code>


#### GenerateDidCompleteListener

<code>(data: <a href="#generatedidcompleteresult">GenerateDidCompleteResult</a>): void</code>


#### GenerateDidCompleteResult

<code>{ state: 'completed' | 'fail'; filePath?: string; error?: string; }</code>

</docgen-api>
